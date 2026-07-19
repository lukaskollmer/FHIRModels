import Foundation


private let asciiDigits: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]


/// Parser for ISO8601 DateTime literals as used in FHIRPath.
/// Implemented in conformance with the `DATE`, `DATETIME`, and `TIME` rules
/// [in the FHIRPath grammar](https://hl7.org/fhirpath/N1/grammar.html)
///
/// Via its ``DateTimeParserProtocol`` conformance (`Input == String`), this type also serves as a
/// strict engine for the FHIR primitive date/time string formats — see the conformance extension
/// at the bottom of this file. (Not `~Copyable`: protocol conformances require copyable types.)
package struct DateTimeLiteralParser<Input: StringProtocol>: ~Copyable {
    struct ParseError: LocalizedError, CustomStringConvertible {
        enum Kind {
            case unexpectedToken(expected: [Character], found: Character?)
            case invalidInput(reason: String)
            case unsupportedLiteral
            // Component-specific kinds, mirroring the legacy `FHIRDateParserError` taxonomy
            // so errors can be translated (and compared) 1:1 across the two engines.
            case invalidSeparator
            case invalidYear
            case invalidMonth
            case invalidDay
            case invalidHour
            case invalidMinute
            case invalidSecond
            case invalidTimeZonePrefix
            case invalidTimeZoneHour
            case invalidTimeZoneMinute
            case additionalCharacters
        }

        let input: String
        let range: Range<String.Index>
        let kind: Kind

        var errorDescription: String? {
            // For the component-specific kinds, mirror the legacy `FHIRDateParserError.errorDescription`
            // phrasing ("Invalid year at [offset] in “input”", with a UTF-16 offset).
            let legacyName: String? = switch kind {
            case .unexpectedToken, .invalidInput, .unsupportedLiteral: nil
            case .invalidSeparator: "Invalid separator"
            case .invalidYear: "Invalid year"
            case .invalidMonth: "Invalid month"
            case .invalidDay: "Invalid day"
            case .invalidHour: "Invalid hour"
            case .invalidMinute: "Invalid minute"
            case .invalidSecond: "Invalid second"
            case .invalidTimeZonePrefix: "Invalid time zone prefix"
            case .invalidTimeZoneHour: "Invalid time zone hour"
            case .invalidTimeZoneMinute: "Invalid time zone minute"
            case .additionalCharacters: "Unexpected characters"
            }
            guard let legacyName else {
                return description
            }
            let utf16Offset = input.utf16.distance(from: input.utf16.startIndex, to: range.lowerBound)
            let preposition = if case .additionalCharacters = kind { "after" } else { "at" }
            return "\(legacyName) \(preposition) [\(utf16Offset)] in “\(input)”"
        }
        
        var description: String {
            let startOffset = input.distance(from: input.startIndex, to: range.lowerBound)
            let endOffset = input.distance(from: input.startIndex, to: range.upperBound)
            return """
                ParseError(
                    kind: \(kind)
                    range: \(startOffset)..<\(endOffset) ('\(input[range])')
                    input: '\(input)'
                )
                """
        }
        
        init(input: Input, range: Range<Input.Index>, kind: Kind) {
            self.input = String(input)
            self.range = range.lowerBound.samePosition(in: self.input)!..<range.upperBound.samePosition(in: self.input)!
            self.kind = kind
        }
    }
    
    
    private let input: Input
    private var position: Input.Index
    
    private let cal: Calendar
    
    fileprivate init(input: Input, position: Input.Index, calendar: Calendar = .defaultForFHIRDateParsing) {
        self.input = input
        self.position = position
        self.cal = calendar
    }
    
    private var current: Character? {
        input[safe: position]
    }
    private var next: Character? {
        input[safe: input.index(after: position)]
    }
    private var isAtEnd: Bool {
        position >= input.endIndex
    }
    private var numRemainingTokens: Int {
        input.distance(from: position, to: input.endIndex)
    }
    
    
    private mutating func consume(_ count: Int = 1) {
        input.formIndex(&position, offsetBy: count)
    }
    
    private func makeError(_ kind: ParseError.Kind, at position: Input.Index) -> ParseError {
        ParseError(
            input: input,
            range: (position < input.endIndex ? position : input.endIndex)..<(position < input.endIndex ? input.index(after: position) : input.endIndex),
            kind: kind
        )
    }
    
    private func makeError(_ kind: ParseError.Kind, in range: Range<Input.Index>) -> ParseError {
        ParseError(input: input, range: range, kind: kind)
    }
    
    /// Checks that the current token is equal to the specified expected value.
    /// If yes, the token is consumed (i.e., the position is advanced by 1).
    /// - Throws: if the current token is not equal to the specified expected value.
    private mutating func expectAndConsume(_ expected: Character, errorKind: ParseError.Kind? = nil) throws(ParseError) {
        if current == expected {
            consume()
        } else {
            throw makeError(errorKind ?? .unexpectedToken(expected: [expected], found: current), at: position)
        }
    }
    
    /// Checks that the current token is equal to one of the specified expected values.
    /// If yes, the token is consumed (i.e., the position is advanced by 1).
    /// - parameter expected: Non-empty list of tokens we allow to appear at the current position.
    /// - Throws: if the current token is not equal to the specified expected value.
    /// - Returns: the token that matched.
    private mutating func expectAnyOfAndConsume(_ expected: [Character], errorKind: ParseError.Kind? = nil) throws(ParseError) -> Character {
        if let current, expected.contains(current) {
            consume()
            return current
        } else {
            throw makeError(
                errorKind ?? .unexpectedToken(expected: expected, found: current),
                at: position
            )
        }
    }
}


extension DateTimeLiteralParser {
    private enum IntParsingNumDigitsRule {
        case exactly(Int)
        case atMost(Int)
    }
    
    /// Parses a decimal `Int`, consuming its digits and returning the resulting value.
    /// - Note: This function will consume tokens until it reaches the first which is not an ASCII decimal digit character.
    /// - Throws: if, when the function is called, the first token is not a decimal digit.
    private mutating func parseInt<I: FixedWidthInteger>(_: I.Type = Int.self, numDigitsRule: IntParsingNumDigitsRule? = nil, errorKind: ParseError.Kind? = nil) throws(ParseError) -> I {
        guard !isAtEnd else {
            throw makeError(errorKind ?? .unexpectedToken(expected: asciiDigits, found: nil), at: position)
        }
//        if let current, !asciiDigits.contains(current) {
//            throw makeError(.unexpectedToken(expected: asciiDigits, found: current), at: position)
//        }
        let startPos = position
        let digits = input[position...].prefix { asciiDigits.contains($0) }
        guard !digits.isEmpty else {
            throw makeError(errorKind ?? .unexpectedToken(expected: asciiDigits, found: current), at: position)
        }
        consume(digits.count)
        let literalRange = startPos..<position
        switch numDigitsRule {
        case nil:
            break
        case .exactly(let limit):
            guard digits.count == limit else {
                throw makeError(errorKind ?? .invalidInput(reason: "Expected \(limit)-digit integer literal; but found \(digits.count) digit(s)"), in: literalRange)
            }
        case .atMost(let limit):
            guard digits.count <= limit else {
                throw makeError(errorKind ?? .invalidInput(reason: "Expected \(limit)-digit integer literal; but found \(digits.count) digit(s)"), in: literalRange)
            }
        }
        var value: I = 0
        for digit in digits {
            let multiplyResult = value.multipliedReportingOverflow(by: 10)
            guard !multiplyResult.overflow else {
                throw makeError(errorKind ?? .invalidInput(reason: "integer literal overflow"), in: literalRange)
            }
            value = multiplyResult.partialValue
            // SAFETY: we know that current is an ascii character, and we know that the "0" literal is an ascii character.
            // Therefore, we can safely access the asciiValue for both of them.
            value += I(digit.asciiValue! - ("0" as Character).asciiValue!) // swiftlint:disable:this force_unwrapping
        }
        return value
    }
    
    
    private mutating func parseDecimal(allowOmittingFractionalPart: Bool = true, errorKind: ParseError.Kind? = nil) throws(ParseError) -> Decimal {
        guard !isAtEnd else {
            throw makeError(errorKind ?? .unexpectedToken(expected: asciiDigits, found: nil), at: position)
        }
//        if let current, !asciiDigits.contains(current) {
//            throw makeError(.unexpectedToken(expected: asciiDigits, found: current), at: position)
//        }
        let startPos = position
        let integerPart = input[position...].prefix { asciiDigits.contains($0) }
        guard !integerPart.isEmpty else {
            throw makeError(errorKind ?? .unexpectedToken(expected: asciiDigits, found: current), at: position)
        }
        consume(integerPart.count)
        let decimalString: Input.SubSequence
        if current == "." {
            consume()
            // parse fractional part
            let fractionPart = input[position...].prefix { asciiDigits.contains($0) }
            guard !fractionPart.isEmpty else {
                throw makeError(errorKind ?? .unexpectedToken(expected: asciiDigits, found: current), at: position) // TODO better error!
            }
            consume(fractionPart.count)
            decimalString = input[integerPart.startIndex..<fractionPart.endIndex]
        } else {
            // integer part not followed by a "."
            if allowOmittingFractionalPart {
                decimalString = integerPart
            } else {
                throw makeError(errorKind ?? .invalidInput(reason: "Decimal is missing fractional part"), in: startPos..<position)
            }
        }
        do {
            return try Decimal(String(decimalString), format: .localizedDecimal(locale: .enUS), lenient: false)
        } catch {
            throw makeError(errorKind ?? .invalidInput(reason: "Failed to parse into Decimal"), in: startPos..<position)
        }
    }
}


extension DateTimeLiteralParser {
    fileprivate enum TimeZoneValidation {
//        /// `('Z' | ('+' | '-') [0-9][0-9]':'[0-9][0-9])`
//        case relaxedSuitableForFHIRPath
        /// `(Z|(\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))`
        case strict
    }
    
    fileprivate mutating func parseTimeZoneComponent(validation: TimeZoneValidation) throws(ParseError) -> (secondsFromGMT: Int, timeZoneString: Input.SubSequence) {
        let startPos = position
        guard current != "Z" else {
            // if the time zone is 'Z', it is interpreted UTC.
            consume()
            return (0, input[startPos..<position])
        }
        let `operator`: Character
        let hours: Int
        let minutes: Int
        switch validation {
//        case .relaxedSuitableForFHIRPath:
//            `operator` = try expectAnyOfAndConsume(["+", "-"])
//            hours = try parseInt(numDigitsRule: .exactly(2))
//            try expectAndConsume(":")
//            minutes = try parseInt(numDigitsRule: .exactly(2))
        case .strict:
            // The dedicated field parsers replicate the legacy engine's error kinds and positions,
            // including the ±14:00 range rules.
            `operator` = try expectAnyOfAndConsume(["+", "-"], errorKind: .invalidTimeZonePrefix)
            hours = try parseFHIRTimeZoneHour()
            try expectAndConsume(":", errorKind: .invalidSeparator)
            minutes = try parseFHIRTimeZoneMinute(hours: hours)
        }
        let timeZoneString = input[startPos..<position]
        var offsetInSeconds = 0
        offsetInSeconds += hours * 60 * 60
        offsetInSeconds += minutes * 60
        offsetInSeconds *= `operator` == "-" ? -1 : 1
        return (offsetInSeconds, timeZoneString)
    }
}


// MARK: Utilities

extension Collection {
    subscript(safe idx: Index) -> Element? {
        // Bounds-compare rather than `indices.contains(idx)`: the latter is a linear walk for
        // string indices, which would make character-by-character parsing quadratic.
        idx >= startIndex && idx < endIndex ? self[idx] : nil
    }
}







extension DateTimeLiteralParser {
    /// Checks that the parser has reached the end of the input, and throws an error if not.
    fileprivate func expectIsAtEnd() throws(ParseError) {
        guard isAtEnd else {
            throw makeError(.additionalCharacters, in: position..<input.endIndex)
        }
    }
    
    
    /// Parses a 2-digit clock field (hour, minute, or the integer part of the seconds), matching the
    /// legacy Scanner engine's error shapes: an empty or out-of-range field reports `kind` at the
    /// field's start, while a non-empty wrong-width digit run reports `invalidSeparator` positioned
    /// *after* the scanned digits.
    private mutating func parseFHIRClockField(max: Int, kind: ParseError.Kind) throws(ParseError) -> UInt8 {
        let start = position
        let digits = input[position...].prefix { asciiDigits.contains($0) }
        guard !digits.isEmpty else {
            throw makeError(kind, at: start)
        }
        consume(digits.count)
        guard digits.count == 2 else {
            throw makeError(.invalidSeparator, at: position)
        }
        let value = UInt8(String(digits))! // SAFETY: exactly two ASCII digits, i.e. at most 99. swiftlint:disable:this force_unwrapping
        guard Int(value) <= max else {
            throw makeError(kind, in: start..<position)
        }
        return value
    }

    /// Parses the 2-digit timezone-offset hour, matching the legacy engine's error shapes
    /// (including the `invalidSeparator` at `start + min(2, count)` width quirk).
    private mutating func parseFHIRTimeZoneHour() throws(ParseError) -> Int {
        let start = position
        let digits = input[position...].prefix { asciiDigits.contains($0) }
        guard !digits.isEmpty else {
            throw makeError(.invalidTimeZoneHour, at: start)
        }
        consume(digits.count)
        guard digits.count == 2 else {
            throw makeError(.invalidSeparator, at: input.index(start, offsetBy: min(2, digits.count)))
        }
        let value = Int(String(digits))! // SAFETY: exactly two ASCII digits. swiftlint:disable:this force_unwrapping
        guard value <= 14 else {
            throw makeError(.invalidTimeZoneHour, in: start..<position)
        }
        return value
    }

    /// Parses the 2-digit timezone-offset minute, matching the legacy engine's error shapes
    /// (`additionalCharacters` at `start + 2` for over-long runs; `invalidTimeZoneMinute` at the
    /// field start otherwise, including the "±14:00 requires zero minutes" rule).
    private mutating func parseFHIRTimeZoneMinute(hours: Int) throws(ParseError) -> Int {
        let start = position
        let digits = input[position...].prefix { asciiDigits.contains($0) }
        guard !digits.isEmpty else {
            throw makeError(.invalidTimeZoneMinute, at: start)
        }
        consume(digits.count)
        guard digits.count <= 2 else {
            throw makeError(.additionalCharacters, at: input.index(start, offsetBy: 2))
        }
        guard digits.count == 2 else {
            throw makeError(.invalidTimeZoneMinute, in: start..<position)
        }
        let value = Int(String(digits))! // SAFETY: exactly two ASCII digits. swiftlint:disable:this force_unwrapping
        guard value <= 59, hours < 14 || value == 0 else {
            throw makeError(.invalidTimeZoneMinute, in: start..<position)
        }
        return value
    }

    fileprivate mutating func parseInstant() throws(ParseError) -> ParsedInstant {
        // YYYY-MM-DDThh:mm:ss.sss+zz:zz
        let startPos = position
        let date = try parseInstantDate()
        try expectAndConsume("T", errorKind: .invalidSeparator)
        let time = try parseTime()
        let (timeZoneOffset, timeZoneString) = try parseTimeZoneComponent(validation: .strict)
        guard (1...9999).contains(date.year), (1...12).contains(date.month), (1...31).contains(date.day),
              let timeZone = TimeZone(secondsFromGMT: timeZoneOffset),
              case let result = ParsedInstant(date: date, time: .init(time: time, timeZone: timeZone, timeZoneString: String(timeZoneString))),
              result.isValid(in: cal) else {
            let text = input[startPos..<position]
            throw makeError(.invalidInput(reason: "\(text) does not correspond to a valid date!"), in: startPos..<position)
        }
        return result
    }
    
    fileprivate mutating func parseInstantDate() throws(ParseError) -> ParsedInstant.Date {
        let startPos = position
        let year = try parseInt(numDigitsRule: .exactly(4), errorKind: .invalidYear)
        guard (1...9999).contains(year) else {
            throw makeError(.invalidYear, in: startPos..<position)
        }
        try expectAndConsume("-", errorKind: .invalidSeparator)
        let monthStart = position
        let month = try parseInt(UInt8.self, numDigitsRule: .exactly(2), errorKind: .invalidMonth)
        guard DateComponents(year: year, month: Int(month)).isValidDate(in: cal) else {
            throw makeError(.invalidMonth, in: monthStart..<position)
        }
        try expectAndConsume("-", errorKind: .invalidSeparator)
        let dayStart = position
        let day = try parseInt(UInt8.self, numDigitsRule: .exactly(2), errorKind: .invalidDay)
        guard DateComponents(year: year, month: Int(month), day: Int(day)).isValidDate(in: cal) else {
            throw makeError(.invalidDay, in: dayStart..<position)
        }
        return .init(year: year, month: month, day: day)
    }
    
    
    fileprivate mutating func parseTime() throws(ParseError) -> ParsedTime {
        let hour = try parseFHIRClockField(max: 23, kind: .invalidHour)
        try expectAndConsume(":", errorKind: .invalidSeparator)
        let minute = try parseFHIRClockField(max: 59, kind: .invalidMinute)
        try expectAndConsume(":", errorKind: .invalidSeparator)
        let secondsStringStart = position
        // Integer seconds may be 60 (the leap second); a fraction may follow (the R4 regex permits
        // "60.5", so — unlike the legacy engine — no cap is applied to the fractional part).
        _ = try parseFHIRClockField(max: 60, kind: .invalidSecond)
        if current == "." {
            consume()
            let fractionStart = position
            let fraction = input[position...].prefix { asciiDigits.contains($0) }
            guard !fraction.isEmpty else {
                throw makeError(.invalidSecond, at: fractionStart)
            }
            consume(fraction.count)
        }
        let secondsString = input[secondsStringStart..<position]
        guard let second = Decimal(string: String(secondsString)) else {
            // Unreachable: `secondsString` is ASCII digits with at most one '.'.
            throw makeError(.invalidSecond, in: secondsStringStart..<position)
        }
        return .init(hour: hour, minute: minute, second: second, originalSecondsString: String(secondsString))
    }
    
    
    fileprivate mutating func parseDate() throws(ParseError) -> ParsedDate {
        // YYYY, YYYY-MM, or YYYY-MM-DD
        let startPos = position
        let year = try parseInt(numDigitsRule: .exactly(4), errorKind: .invalidYear)
        guard (1...9999).contains(year) else {
            throw makeError(.invalidYear, in: startPos..<position)
        }
        guard current == "-" else {
            return .init(year: year)
        }
        consume()
        let monthStart = position
        let month = try parseInt(UInt8.self, numDigitsRule: .exactly(2), errorKind: .invalidMonth)
        guard DateComponents(year: year, month: Int(month)).isValidDate(in: cal) else {
            throw makeError(.invalidMonth, in: monthStart..<position)
        }
        guard current == "-" else {
            return .init(year: year, month: month)
        }
        consume()
        let dayStart = position
        let day = try parseInt(UInt8.self, numDigitsRule: .exactly(2), errorKind: .invalidDay)
        guard DateComponents(year: year, month: Int(month), day: Int(day)).isValidDate(in: cal) else {
            throw makeError(.invalidDay, in: dayStart..<position)
        }
        return .init(year: year, month: month, day: day)
    }
    
    
    fileprivate mutating func parseDateTime() throws(ParseError) -> ParsedDateTime {
        // YYYY
        // YYYY-MM
        // YYYY-MM-DD
        // YYYY-MM-DDThh:mm:ss+zz:zz
        let startPos = position
        let date = try parseDate()
        guard current == "T" else {
            return .init(date: date, time: nil)
        }
        let timeSeparatorPos = position
        consume()
        let time = try parseTime()
        let (timeZoneOffset, timeZoneString) = try parseTimeZoneComponent(validation: .strict)
        guard let timeZone = TimeZone(secondsFromGMT: timeZoneOffset),
              case let result = ParsedDateTime(date: date, time: .init(time: time, timeZone: timeZone, timeZoneString: String(timeZoneString))),
              result.isValid(in: cal) else {
            if date.day == nil {
                // A time may only follow a complete date (intentionally stricter than the legacy engine).
                throw makeError(.additionalCharacters, at: timeSeparatorPos)
            }
            let text = input[startPos..<position]
            throw makeError(.invalidInput(reason: "'\(text)' is not a valid date"), in: startPos..<position)
        }
        return result
    }
}

extension ParsedInstant {
    func isValid(in cal: Calendar) -> Bool {
        guard date.year > 0 && date.year <= 9999 else {
            return false
        }
        let (seconds, nanoseconds) = time.time.second.secondsAndNanoseconds()
        var components = DateComponents(
            timeZone: time.timeZone,
            year: date.year,
            month: Int(date.month),
            day: Int(date.day),
            hour: Int(time.time.hour),
            minute: Int(time.time.minute),
            second: seconds,
            nanosecond: nanoseconds
        )
        if seconds == 60, nanoseconds == 0 {
            components.second! -= 1
        }
        var cal = cal
        cal.timeZone = time.timeZone
        return components.isValidDate(in: cal)
    }
}


extension ParsedDate {
    func isValid(in cal: Calendar) -> Bool {
        guard year > 0 && year <= 9999 else {
            return false
        }
        return switch (month, day) {
        case (.none, .none):
            true
        case (.some(let month), .none):
            DateComponents(year: year, month: Int(month)).isValidDate(in: cal)
        case (.some(let month), .some(let day)):
            DateComponents(year: year, month: Int(month), day: Int(day)).isValidDate(in: cal)
        case (.none, .some):
            // day without month is not allowed
            false
        }
    }
}

extension ParsedDateTime {
    func isValid(in cal: Calendar) -> Bool {
        if let time {
            guard let month = date.month, let day = date.day else {
                // if there is a time, we must also have a month and day.
                return false
            }
            let (seconds, nanoseconds) = time.time.second.secondsAndNanoseconds()
            var components = DateComponents(
                timeZone: time.timeZone,
                year: date.year,
                month: Int(month),
                day: Int(day),
                hour: Int(time.time.hour),
                minute: Int(time.time.minute),
                second: seconds,
                nanosecond: nanoseconds == 0 ? nil : nanoseconds
            )
            if seconds == 60, nanoseconds == 0 {
                // leap second
                components.second! -= 1
            }
            var cal = cal
            cal.timeZone = time.timeZone
            return components.isValidDate(in: cal)
        } else {
            // date-only
            return date.isValid(in: cal)
        }
    }
}


extension Decimal {
    func secondsAndNanoseconds() -> (seconds: Int, nanoseconds: Int) {
        var input = self
        var whole = Decimal()
        // .down = toward -inf, .up = toward +inf → this truncates toward zero
        NSDecimalRound(&whole, &input, 0, self < 0 ? .up : .down)
        var scaledFrac = (self - whole) * 1_000_000_000
        var nanos = Decimal()
        NSDecimalRound(&nanos, &scaledFrac, 0, self < 0 ? .up : .down)
        return (
            NSDecimalNumber(decimal: whole).intValue,
            NSDecimalNumber(decimal: nanos).intValue
        )
    }
}



// MARK: DateTimeParserProtocol

extension DateTimeLiteralParser.ParseError {
    /// Converts a `ParseError` into an equivalent `FHIRDateParserError`, for backward compatibility.
    ///
    /// This will preserve the kind 1:1 and the UTF-16 offset of the error's start.
    var fhirDateParserError: FHIRDateParserError {
        let location = input.utf16.distance(from: input.utf16.startIndex, to: range.lowerBound)
        let position = FHIRDateParserErrorPosition(string: input, location: location)
        return switch kind {
        case .invalidSeparator: .invalidSeparator(position)
        case .invalidYear: .invalidYear(position)
        case .invalidMonth: .invalidMonth(position)
        case .invalidDay: .invalidDay(position)
        case .invalidHour: .invalidHour(position)
        case .invalidMinute: .invalidMinute(position)
        case .invalidSecond: .invalidSecond(position)
        case .invalidTimeZonePrefix: .invalidTimeZonePrefix(position)
        case .invalidTimeZoneHour: .invalidTimeZoneHour(position)
        case .invalidTimeZoneMinute: .invalidTimeZoneMinute(position)
        case .additionalCharacters: .additionalCharacters(position)
        case .unexpectedToken, .invalidInput, .unsupportedLiteral:
            // Fallback for the generic kinds; the classified FHIR entry points only reach this
            // on composite validity failures.
            .additionalCharacters(position)
        }
    }
}

package enum NewDateTimeParser: DateTimeParserProtocol {
    package static func dateComponents(from input: some StringProtocol) throws -> ParsedDate {
        do {
            var parser = DateTimeLiteralParser(input: input, position: input.startIndex)
            let date = try parser.parseDate()
            try parser.expectIsAtEnd()
            return date
        } catch {
            throw error.fhirDateParserError
        }
    }

    package static func instantDateComponents(from input: some StringProtocol) throws -> ParsedInstant.Date {
        do {
            var parser = DateTimeLiteralParser(input: input, position: input.startIndex)
            let date = try parser.parseInstantDate()
            try parser.expectIsAtEnd()
            return date
        } catch {
            throw error.fhirDateParserError
        }
    }

    package static func timeComponents(from input: some StringProtocol) throws -> ParsedTime {
        do {
            var parser = DateTimeLiteralParser(input: input, position: input.startIndex)
            let time = try parser.parseTime()
            try parser.expectIsAtEnd()
            return time
        } catch {
            throw error.fhirDateParserError
        }
    }

    package static func dateTimeComponents(from input: some StringProtocol) throws -> ParsedDateTime {
        do {
            var parser = DateTimeLiteralParser(input: input, position: input.startIndex)
            let result = try parser.parseDateTime()
            try parser.expectIsAtEnd()
            return result
        } catch {
            throw error.fhirDateParserError
        }
    }

    package static func instantComponents(from input: some StringProtocol) throws -> ParsedInstant {
        do {
            var parser = DateTimeLiteralParser(input: input, position: input.startIndex)
            let instant = try parser.parseInstant()
            try parser.expectIsAtEnd()
            return instant
        } catch {
            throw error.fhirDateParserError
        }
    }

    package static func timeZoneComponents(from input: some StringProtocol) throws -> ParsedTimeZone {
        do {
            var parser = DateTimeLiteralParser(input: input, position: input.startIndex)
            let result = try parser.parseTimeZoneComponent(validation: .strict)
            try parser.expectIsAtEnd()
            return ParsedTimeZone(secondsFromGMT: result.secondsFromGMT, timeZoneString: String(result.timeZoneString))
        } catch {
            throw error.fhirDateParserError
        }
    }
}


extension Locale {
    fileprivate static let enUS = Locale(identifier: "en_US")
}


extension Calendar {
    fileprivate static let defaultForFHIRDateParsing: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .gmt
        cal.locale = .enUS
        return cal
    }()
}
