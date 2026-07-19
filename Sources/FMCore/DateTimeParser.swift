//
//  DateTimeParser.swift
//  HealthSoftware
//
//  Copyright 2026 Apple Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

package typealias DateTimeParser = ScannerDateTimeParser
//package typealias DateTimeParser = NewDateTimeParser


/// Controls the ``NewDateTimeParser``'s behaviour.
package struct DateTimeParserConfig {
    /// The range of allowed years, e.g. `0001..<10_000`
    let allowedYears: Range<Int>
    /// Whether the parser should allow leap seconds, expressed as a seconds component with value `60`.
    let allowLeapSecond60: Bool
    /// The maximum number of fractional digits allowed in a seconds component.
    let maxFractionalSecondDigits: Int?
}


extension DateTimeParserConfig {
    /// Parser config suitable for parsing DSTU2 Date/Time/DateTime/Instant values.
    package static let dstu2 = Self(
        allowedYears: -9999..<10000,
        allowLeapSecond60: false,
        maxFractionalSecondDigits: nil
    )
    
    /// Parser config suitable for parsing STU3 Date/Time/DateTime/Instant values.
    package static let stu3 = dstu2
    
    /// Parser config suitable for parsing R4 Date/Time/DateTime/Instant values.
    package static let r4 = Self(
        allowedYears: 1..<10000,
        allowLeapSecond60: true,
        maxFractionalSecondDigits: nil
    )
    
    /// Parser config suitable for parsing R4B Date/Time/DateTime/Instant values.
    package static let r4b = r4
    
    /// Parser config suitable for parsing R5 Date/Time/DateTime/Instant values.
    package static let r5 = Self(
        allowedYears: 1..<10000,
        allowLeapSecond60: true,
        maxFractionalSecondDigits: 9
    )
    
    /// Parser config suitable for parsing R6 Date/Time/DateTime/Instant values.
    package static let r6 = r5
}


/// temporary protocol to allow switching parser implementations
///
/// not actually used directly except in the tests. main purpose is to ensure that the 2 parsers (``ScannerDateTimeParser`` and ``NewDateTimeParser``) share a common interface.
package protocol DateTimeParserProtocol: ~Copyable, SendableMetatype {
    /// Parses a FHIR "date" string: `YYYY`, `YYYY-MM`, or `YYYY-MM-DD`.
    /// Omitted components are `nil` (reduced precision), which is semantically distinct from any value.
    static func dateComponents(from input: some StringProtocol, config: DateTimeParserConfig) throws -> ParsedDate

    /// Parses a FHIR "date" string for use in `Instant`, requiring all of `YYYY-MM-DD` to be present.
    static func instantDateComponents(from input: some StringProtocol, config: DateTimeParserConfig) throws -> ParsedInstant.Date

    /// Parses a FHIR "time" string: `hh:mm:ss` with an optional fractional-seconds suffix.
    /// The verbatim seconds spelling (including trailing zeros) is preserved in
    /// ``ParsedTime/originalSecondsString``.
    static func timeComponents(from input: some StringProtocol, config: DateTimeParserConfig) throws -> ParsedTime

    /// Parses a FHIR "dateTime" string: a (possibly partial) date, optionally followed by
    /// `'T'` + time + timezone offset.
    static func dateTimeComponents(from input: some StringProtocol, config: DateTimeParserConfig) throws -> ParsedDateTime

    /// Parses a FHIR "instant" string: a full date, `'T'`, a seconds-precision time, and a
    /// mandatory timezone offset.
    static func instantComponents(from input: some StringProtocol, config: DateTimeParserConfig) throws -> ParsedInstant

    /// Parses a standalone timezone string: `Z` or `±hh:mm` within `-14:00...+14:00`.
    /// The verbatim spelling (e.g. `+00:00` vs `Z`) is preserved in ``ParsedTimeZone/timeZoneString``.
    static func timeZoneComponents(from input: some StringProtocol, config: DateTimeParserConfig) throws -> ParsedTimeZone
}




package struct ParsedDate: Hashable {
    package let year: Int
    package let month: UInt8?
    package let day: UInt8?
    
    package init(year: Int) {
        self.year = year
        self.month = nil
        self.day = nil
    }
    
    package init(year: Int, month: UInt8) {
        self.year = year
        self.month = month
        self.day = nil
    }
    
    package init(year: Int, month: UInt8, day: UInt8) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    @available(*, deprecated)
    package init(year: Int, month: UInt8?, day: UInt8?) {
        if month == nil {
            precondition(day == nil)
        }
        self.year = year
        self.month = month
        self.day = day
    }
}


package struct ParsedTime: Hashable {
    package let hour: UInt8
    package let minute: UInt8
    package let second: Decimal
    package let secondIntegerPart: UInt8
    package let originalSecondsString: String

    package init(hour: UInt8, minute: UInt8, second: Decimal, secondIntegerPart: UInt8, originalSecondsString: String) {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.secondIntegerPart = secondIntegerPart
        self.originalSecondsString = originalSecondsString
    }
}


package struct ParsedDateTime: Hashable {
    package struct TimeComponent: Hashable {
        package let time: ParsedTime
        package let timeZone: TimeZone
        package let timeZoneString: String

        package init(time: ParsedTime, timeZone: TimeZone, timeZoneString: String) {
            self.time = time
            self.timeZone = timeZone
            self.timeZoneString = timeZoneString
        }
    }

    package let date: ParsedDate
    package let time: TimeComponent?

    package init(date: ParsedDate, time: TimeComponent?) {
        self.date = date
        self.time = time
    }
}


package struct ParsedInstant: Hashable {
    package struct Date: Hashable {
        package let year: Int
        package let month: UInt8
        package let day: UInt8

        package init(year: Int, month: UInt8, day: UInt8) {
            self.year = year
            self.month = month
            self.day = day
        }
    }

    package let date: Date
    package let time: ParsedDateTime.TimeComponent

    package init(date: Date, time: ParsedDateTime.TimeComponent) {
        self.date = date
        self.time = time
    }
}


package struct ParsedTimeZone: Hashable {
    package let secondsFromGMT: Int
    package let timeZoneString: String

    package init(secondsFromGMT: Int, timeZoneString: String) {
        self.secondsFromGMT = secondsFromGMT
        self.timeZoneString = timeZoneString
    }
}
