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

//package typealias DateTimeParser = ScannerDateTimeParser
package typealias DateTimeParser = NewDateTimeParser


/// A parsing engine for the string representations of the FHIR date/time primitive types
/// (`FHIRDate`, `FHIRTime`, `DateTime`, `Instant`, `InstantDate`) and their timezone offsets.
///
/// This protocol is the seam that allows swapping the parsing implementation (e.g. the `Scanner`-based
/// ``ScannerDateTimeParser`` vs. a hand-written token parser) without touching the primitive types
/// themselves: each method takes the complete source string and returns validated components, including
/// the verbatim spellings (`originalSecondsString`, `timeZoneString`) that lexical round-tripping of
/// `description`/`Codable` depends on.
///
/// Requirements on every conformer:
/// - The entire input string must be consumed; trailing characters are an error.
/// - Failures must be thrown as ``FHIRDateParserError``, carrying the full input string and the
///   UTF-16 offset of the offending position.
/// - The observable behavior (accepted inputs, component values, error cases and positions) is pinned
///   by the ScannerParsingCharacterization test suite; a conformer is a valid engine when it passes
///   that suite.
package protocol DateTimeParserProtocol: ~Copyable, SendableMetatype {

    /// Parses a FHIR "date" string: `YYYY`, `YYYY-MM`, or `YYYY-MM-DD`.
    /// Omitted components are `nil` (reduced precision), which is semantically distinct from any value.
    static func dateComponents(from input: some StringProtocol) throws -> ParsedDate

    /// Parses a FHIR "date" string for use in `Instant`, requiring all of `YYYY-MM-DD` to be present.
    static func instantDateComponents(from input: some StringProtocol) throws -> ParsedInstant.Date

    /// Parses a FHIR "time" string: `hh:mm:ss` with an optional fractional-seconds suffix.
    /// The verbatim seconds spelling (including trailing zeros) is preserved in
    /// ``ParsedTime/originalSecondsString``.
    static func timeComponents(from input: some StringProtocol) throws -> ParsedTime

    /// Parses a FHIR "dateTime" string: a (possibly partial) date, optionally followed by
    /// `'T'` + time + timezone offset.
    static func dateTimeComponents(from input: some StringProtocol) throws -> ParsedDateTime

    /// Parses a FHIR "instant" string: a full date, `'T'`, a seconds-precision time, and a
    /// mandatory timezone offset.
    static func instantComponents(from input: some StringProtocol) throws -> ParsedInstant

    /// Parses a standalone timezone string: `Z` or `±hh:mm` within `-14:00...+14:00`.
    /// The verbatim spelling (e.g. `+00:00` vs `Z`) is preserved in ``ParsedTimeZone/timeZoneString``.
    static func timeZoneComponents(from input: some StringProtocol) throws -> ParsedTimeZone
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
    package let originalSecondsString: String

    package init(hour: UInt8, minute: UInt8, second: Decimal, originalSecondsString: String) {
        self.hour = hour
        self.minute = minute
        self.second = second
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
