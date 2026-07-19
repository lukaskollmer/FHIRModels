//
//  ScannerParsingCharacterizationTests.swift
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

import FMCore
import Foundation
import ModelsR5
import Testing

/*
 Characterization tests for the Scanner-based Date/Time/DateTime/TimeZone string parsing.

 Together with FHIRDateTests, FHIRTimeTests, DateTimeTests, InstantTests and TimeZoneTests, these tests pin the
 exact observable behavior of the current parsing implementation — accepted inputs, parsed component values,
 description/round-trip fidelity, and the exact `FHIRDateParserError` case and position for rejected inputs —
 so that a future replacement of the parsing engine can be validated against them.

 All model targets (ModelsDSTU2 through ModelsBuild) contain byte-identical copies of the date/time source
 files; CrossTargetConsistencyTests guards that invariant, so testing the ModelsR5 copies covers all targets.

 Behaviors of the current implementation that are considered *bugs* are deliberately NOT pinned here;
 they live in ScannerParsingKnownIssueTests.swift as `withKnownIssue` tests asserting the correct behavior.
 */

// MARK: - FHIRDate

@Suite(.serialized)
struct FHIRDateParsingCharacterization {

	@Test
	func boundaryYearsParse() throws {
		let min = try parseFHIR("0001-01-01", as: FHIRDate.self)
		#expect(min == FHIRDate(year: 1, month: 1, day: 1))
		#expect(min.description == "0001-01-01")

		let max = try parseFHIR("9999-12-31", as: FHIRDate.self)
		#expect(max == FHIRDate(year: 9999, month: 12, day: 31))
		#expect(max.description == "9999-12-31")
	}

	/// Components must be exactly 2 digits wide (and the year exactly 4).
	@Test
	func wrongWidthComponentsRejected() {
		expectParserError(parsing: "2019-1-7", as: FHIRDate.self, toThrow: .invalidMonth(position("2019-1-7", 5)))
		expectParserError(parsing: "2019-1", as: FHIRDate.self, toThrow: .invalidMonth(position("2019-1", 5)))
		expectParserError(parsing: "2019-013-01", as: FHIRDate.self, toThrow: .invalidMonth(position("2019-013-01", 5)))
		expectParserError(parsing: "2019-01-7", as: FHIRDate.self, toThrow: .invalidDay(position("2019-01-7", 8)))
	}

	/// `CharacterSet.decimalDigits` scans any Unicode digit (Nd), but the subsequent `Int`/`UInt8`
	/// conversion is ASCII-only, so non-ASCII digits fail with the component error, not a separator error.
	@Test
	func nonASCIIDigitsRejected() {
		expectParserError(parsing: "٢٠١٩", as: FHIRDate.self, toThrow: .invalidYear(position("٢٠١٩", 0)))			// Arabic-Indic
		expectParserError(parsing: "２０１９", as: FHIRDate.self, toThrow: .invalidYear(position("２０１９", 0)))	// Fullwidth
		expectParserError(parsing: "2019-٠١", as: FHIRDate.self, toThrow: .invalidMonth(position("2019-٠١", 5)))
	}
}

// MARK: - FHIRTime

@Suite(.serialized)
struct FHIRTimeParsingCharacterization {

	/// R4 explicitly allows the leap second (second == 60); also without a fractional part.
	@Test
	func leapSecondParses() throws {
		let time = try parseFHIR("09:41:60", as: FHIRTime.self)
		#expect(time.hour == 9)
		#expect(time.minute == 41)
		#expect(time.second == 60)
		#expect(time.originalSecondsString == "60")
		#expect(time.description == "09:41:60")

		expectParserError(parsing: "09:41:61", as: FHIRTime.self, toThrow: .invalidSecond(position("09:41:61", 6)))
	}

	/// The original seconds string is preserved verbatim even beyond `Decimal` precision,
	/// so extremely long fractions still round-trip exactly.
	@Test
	func longFractionRoundTripsViaOriginalSecondsString() throws {
		let fraction = String(repeating: "1", count: 40)
		let string = "12:30:45." + fraction
		let time = try parseFHIR(string, as: FHIRTime.self)
		#expect(time.originalSecondsString == "45." + fraction)
		#expect(time.description == string)
	}
}

// MARK: - DateTime

@Suite(.serialized)
struct DateTimeParsingCharacterization {

	/// FHIR dateTime: "If hours and minutes are specified, a timezone SHALL be populated."
	@Test
	func timeZoneIsMandatoryWhenTimeIsPresent() {
		expectParserError(
			parsing: "2015-02-07T13:28:17",
			as: DateTime.self,
			toThrow: .invalidTimeZonePrefix(position("2015-02-07T13:28:17", 19))
		)
		expectParserError(
			parsing: "2015-02-07T13:28:17.239",
			as: DateTime.self,
			toThrow: .invalidTimeZonePrefix(position("2015-02-07T13:28:17.239", 23))
		)
	}

	/// A dangling 'T' after the date (valid as a FHIRPath partial literal) is not a valid FHIR dateTime.
	@Test
	func danglingTimeSeparatorRejected() {
		expectParserError(parsing: "2015-02-07T", as: DateTime.self, toThrow: .invalidHour(position("2015-02-07T", 11)))
		expectParserError(parsing: "2015-02-07T ", as: DateTime.self, toThrow: .invalidHour(position("2015-02-07T ", 11)))
	}

	/// FHIR requires the time to be specified down to (at least) the second.
	@Test
	func secondsAreMandatoryWhenTimeIsPresent() {
		expectParserError(
			parsing: "2015-02-07T13:28-05:00",
			as: DateTime.self,
			toThrow: .invalidSeparator(position("2015-02-07T13:28-05:00", 16))
		)
		expectParserError(
			parsing: "2015-02-07T13-05:00",
			as: DateTime.self,
			toThrow: .invalidSeparator(position("2015-02-07T13-05:00", 13))
		)
	}

	/// Component errors in the middle of a dateTime string carry positions in full-string coordinates.
	@Test
	func componentErrorsCarryFullStringPositions() {
		expectParserError(
			parsing: "2015-13-07T13:28:17Z",
			as: DateTime.self,
			toThrow: .invalidMonth(position("2015-13-07T13:28:17Z", 5))
		)
		expectParserError(
			parsing: "2015-02-07T13:60:17Z",
			as: DateTime.self,
			toThrow: .invalidMinute(position("2015-02-07T13:60:17Z", 14))
		)
		expectParserError(
			parsing: "2015-02-07T13:28:61Z",
			as: DateTime.self,
			toThrow: .invalidSecond(position("2015-02-07T13:28:61Z", 17))
		)
	}

	/// All three spellings of UTC parse to the same `TimeZone`, but the original spelling
	/// is preserved (via `originalTimeZoneString`) and round-trips exactly.
	@Test(arguments: ["2017-12-09T09:30:51Z", "2017-12-09T09:30:51+00:00", "2017-12-09T09:30:51-00:00"])
	func utcSpellingIsPreserved(string: String) throws {
		let dateTime = try parseFHIR(string, as: DateTime.self)
		#expect(dateTime.timeZone == TimeZone(secondsFromGMT: 0))
		#expect(dateTime.originalTimeZoneString == String(string.dropFirst(19)))
		#expect(dateTime.description == string)
	}

	/// FHIR limits timezone offsets to -14:00...+14:00; minutes beyond a full ±14:00 are invalid.
	@Test
	func timeZoneOffsetBoundaries() throws {
		let plus14 = try parseFHIR("2015-02-07T13:28:17+14:00", as: DateTime.self)
		#expect(plus14.timeZone == TimeZone(secondsFromGMT: 14 * 3600))
		#expect(plus14.description == "2015-02-07T13:28:17+14:00")

		let minus14 = try parseFHIR("2015-02-07T13:28:17-14:00", as: DateTime.self)
		#expect(minus14.timeZone == TimeZone(secondsFromGMT: -14 * 3600))
		#expect(minus14.description == "2015-02-07T13:28:17-14:00")

		expectParserError(
			parsing: "2015-02-07T13:28:17+15:00",
			as: DateTime.self,
			toThrow: .invalidTimeZoneHour(position("2015-02-07T13:28:17+15:00", 20))
		)
		expectParserError(
			parsing: "2015-02-07T13:28:17+14:01",
			as: DateTime.self,
			toThrow: .invalidTimeZoneMinute(position("2015-02-07T13:28:17+14:01", 23))
		)
		expectParserError(
			parsing: "2015-02-07T13:28:17+05:60",
			as: DateTime.self,
			toThrow: .invalidTimeZoneMinute(position("2015-02-07T13:28:17+05:60", 23))
		)
	}

	@Test
	func trailingCharactersAfterTimeZoneRejected() {
		expectParserError(
			parsing: "2015-02-07T13:28:17-05:00x",
			as: DateTime.self,
			toThrow: .additionalCharacters(position("2015-02-07T13:28:17-05:00x", 25))
		)
		expectParserError(
			parsing: "2015-02-07T13:28:17Zx",
			as: DateTime.self,
			toThrow: .additionalCharacters(position("2015-02-07T13:28:17Zx", 20))
		)
		// "…ZZ" is also rejected, but today via invalidTimeZoneHour@21 — an artifact of the "+-Z"
		// run-scan bug (see ScannerParsingKnownIssues.timeZoneSignPrefixRunScan). Only the clean,
		// typed failure is the contract here.
		expectCleanParserError(parsing: "2015-02-07T13:28:17ZZ", as: DateTime.self)
	}

	/// The timezone prefix is case-sensitive (unlike the 'T' separator; see ScannerParsingKnownIssueTests).
	@Test
	func lowercaseZuluRejected() {
		expectParserError(
			parsing: "2015-02-07T13:28:17z",
			as: DateTime.self,
			toThrow: .invalidTimeZonePrefix(position("2015-02-07T13:28:17z", 19))
		)
	}
}

// MARK: - Instant

@Suite(.serialized)
struct InstantParsingCharacterization {

	@Test
	func leapSecondInstantParses() throws {
		let instant = try parseFHIR("2016-12-31T23:59:60Z", as: Instant.self)
		#expect(instant.time.second == 60)
		#expect(instant.description == "2016-12-31T23:59:60Z")
	}

	@Test
	func fractionalTrailingZerosPreserved() throws {
		let instant = try parseFHIR("2017-12-09T09:30:51.000Z", as: Instant.self)
		#expect(instant.time.second == 51)
		#expect(instant.time.originalSecondsString == "51.000")
		#expect(instant.description == "2017-12-09T09:30:51.000Z")
	}

	/// InstantTests pins error *positions* for these; the error cases are part of the contract too.
	@Test
	func errorCasesArePinnedThroughTheInstantEntryPoint() {
		expectParserError(parsing: "2014", as: Instant.self, toThrow: .invalidSeparator(position("2014", 4)))
		expectParserError(parsing: "2016-11-08", as: Instant.self, toThrow: .invalidSeparator(position("2016-11-08", 10)))
		expectParserError(
			parsing: "2017-12-09T09:30:51",
			as: Instant.self,
			toThrow: .invalidTimeZonePrefix(position("2017-12-09T09:30:51", 19))
		)
		expectParserError(
			parsing: "2017-12-09T09:30:51Zx",
			as: Instant.self,
			toThrow: .additionalCharacters(position("2017-12-09T09:30:51Zx", 20))
		)
		expectParserError(
			parsing: "0000-12-09T09:30:51Z",
			as: Instant.self,
			toThrow: .invalidYear(position("0000-12-09T09:30:51Z", 0))
		)
	}

	/// The compact ISO 8601 offset form (±hhmm, without the colon) is not valid FHIR.
	@Test
	func compactTimeZoneOffsetRejected() {
		expectParserError(
			parsing: "2017-12-09T09:30:51+0000",
			as: Instant.self,
			toThrow: .invalidSeparator(position("2017-12-09T09:30:51+0000", 22))
		)
	}

	@Test
	func lowercaseZuluRejected() {
		expectParserError(
			parsing: "2017-12-09T09:30:51z",
			as: Instant.self,
			toThrow: .invalidTimeZonePrefix(position("2017-12-09T09:30:51z", 19))
		)
	}
}

// MARK: - InstantDate

/// `InstantDate` has its own parse implementation (not delegated to `FHIRDate`), so its behavior
/// is pinned separately.
@Suite(.serialized)
struct InstantDateParsingCharacterization {

	@Test
	func fullySpecifiedDateParses() throws {
		let date = try parseFHIR("2017-12-09", as: InstantDate.self)
		#expect(date == InstantDate(year: 2017, month: 12, day: 9))
		#expect(date.description == "2017-12-09")
	}

	/// Unlike `FHIRDate`, a partial date fails with `invalidSeparator` (the missing "-"),
	/// not `additionalCharacters`.
	@Test
	func partialDatesRejected() {
		expectParserError(parsing: "2017", as: InstantDate.self, toThrow: .invalidSeparator(position("2017", 4)))
		expectParserError(parsing: "2017-12", as: InstantDate.self, toThrow: .invalidSeparator(position("2017-12", 7)))
	}

	@Test
	func componentValidationMatchesFHIRDate() {
		expectParserError(parsing: "0000-12-09", as: InstantDate.self, toThrow: .invalidYear(position("0000-12-09", 0)))
		expectParserError(parsing: "2017-1-09", as: InstantDate.self, toThrow: .invalidMonth(position("2017-1-09", 5)))
		expectParserError(parsing: "2017-13-09", as: InstantDate.self, toThrow: .invalidMonth(position("2017-13-09", 5)))
		expectParserError(parsing: "2017-12-9", as: InstantDate.self, toThrow: .invalidDay(position("2017-12-9", 8)))
		expectParserError(parsing: "2017-12-32", as: InstantDate.self, toThrow: .invalidDay(position("2017-12-32", 8)))
		expectParserError(parsing: "2017-12-09x", as: InstantDate.self, toThrow: .additionalCharacters(position("2017-12-09x", 10)))
	}
}

// MARK: - TimeZone

@Suite(.serialized)
struct TimeZoneParsingCharacterization {

	@Test
	func offsetBoundariesParse() throws {
		#expect(try parseFHIR("+14:00", as: TimeZone.self) == TimeZone(secondsFromGMT: 50_400))
		#expect(try parseFHIR("-14:00", as: TimeZone.self) == TimeZone(secondsFromGMT: -50_400))
		#expect(try parseFHIR("+13:59", as: TimeZone.self) == TimeZone(secondsFromGMT: 50_340))
	}

	@Test
	func lowercaseZuluRejected() {
		expectParserError(parsing: "z", as: TimeZone.self, toThrow: .invalidTimeZonePrefix(position("z", 0)))
	}
}

// MARK: - Degenerate inputs

@Suite(.serialized)
struct DegenerateInputCharacterization {

	/// The empty string fails on the first expected component, at position 0, for every entry type.
	/// (The `TimeZone` case is pinned in TimeZoneTests.)
	@Test
	func emptyStringRejectedByEveryEntryPoint() {
		expectParserError(parsing: "", as: FHIRDate.self, toThrow: .invalidYear(position("", 0)))
		expectParserError(parsing: "", as: FHIRTime.self, toThrow: .invalidHour(position("", 0)))
		expectParserError(parsing: "", as: DateTime.self, toThrow: .invalidYear(position("", 0)))
		expectParserError(parsing: "", as: Instant.self, toThrow: .invalidYear(position("", 0)))
		expectParserError(parsing: "", as: InstantDate.self, toThrow: .invalidYear(position("", 0)))
	}

	/// Absurdly long digit runs must produce a clean, typed error — never overflow or crash — through
	/// every entry point: these inits run on untrusted wire data. The exact error case/position is an
	/// artifact of the current width checks (which reject long runs before any integer conversion is
	/// attempted), so only the clean failure itself is pinned.
	@Test
	func oversizedDigitRunsThrowCleanly() {
		let twentyNines = String(repeating: "9", count: 20)
		expectCleanParserError(parsing: twentyNines, as: FHIRDate.self)
		expectCleanParserError(parsing: twentyNines, as: FHIRTime.self)
		expectCleanParserError(parsing: twentyNines, as: DateTime.self)
		expectCleanParserError(parsing: twentyNines, as: Instant.self)
		expectCleanParserError(parsing: String(repeating: "9", count: 18) + "-01-01", as: FHIRDate.self)
		expectCleanParserError(parsing: "2015-02-07T" + twentyNines + ":00:00Z", as: DateTime.self)
		expectCleanParserError(parsing: "+" + twentyNines + ":00", as: TimeZone.self)
	}
}

// MARK: - Scanner composition (public API contract)

/// `DateTime.parse` and `Instant.parse` compose the sub-parsers on one shared `Scanner` via
/// `expectAtEnd: false`; that mid-string composition is public API and any (deprecated-wrapper)
/// replacement must advance the scanner identically.
@Suite(.serialized)
struct ScannerCompositionCharacterization {

	@Test
	func subParsersComposeOnASharedScanner() throws {
		let scanner = Scanner(string: "2018-05-14T09:41:00Z")

		let date = try FHIRDate.parse(from: scanner, expectAtEnd: false)
		#expect(date == FHIRDate(year: 2018, month: 5, day: 14))

		#expect(scanner.scanString("T") != nil)

		let time = try FHIRTime.parse(from: scanner, expectAtEnd: false)
		#expect(time == FHIRTime(hour: 9, minute: 41, second: 0))

		let (secondsFromGMT, timeZoneString) = try TimeZone.hs_parseComponents(from: scanner, expectAtEnd: true)
		#expect(secondsFromGMT == 0)
		#expect(timeZoneString == "Z")
		#expect(scanner.isAtEnd)
	}

	/// With `expectAtEnd: false`, a parse consumes its prefix and leaves trailing content to the caller.
	@Test
	func expectAtEndFalseToleratesTrailingContent() throws {
		let scanner = Scanner(string: "2018-05-14 more")
		let date = try FHIRDate.parse(from: scanner, expectAtEnd: false)
		#expect(date == FHIRDate(year: 2018, month: 5, day: 14))
		#expect(!scanner.isAtEnd)
	}

	@Test
	func parseComponentsReturnsRawSecondsString() throws {
		let (hour, minute, second, originalSecondString) = try FHIRTime.parseComponents(from: Scanner(string: "09:41:00.500"))
		#expect(hour == 9)
		#expect(minute == 41)
		#expect(second == Decimal(string: "0.5"))
		#expect(originalSecondString == "00.500")
	}

	/// The parsers disable the caller's `charactersToBeSkipped` for the duration of the parse
	/// (whitespace inside a value is never skipped) and restore it afterwards.
	@Test
	func charactersToBeSkippedAreDisabledDuringAndRestoredAfterParsing() throws {
		let scanner = Scanner(string: "2018-05-14")
		scanner.charactersToBeSkipped = .whitespaces
		_ = try FHIRDate.parse(from: scanner, expectAtEnd: true)
		#expect(scanner.charactersToBeSkipped == .whitespaces)

		let leadingWhitespace = Scanner(string: " 2018")
		leadingWhitespace.charactersToBeSkipped = .whitespaces
		#expect(throws: FHIRDateParserError.self) {
			try FHIRDate.parse(from: leadingWhitespace, expectAtEnd: true)
		}
	}
}

// MARK: - Codable

/// Encoding goes through `description`, so lexical fidelity (precision, fraction spelling, timezone
/// spelling) must survive an actual JSON decode/encode cycle.
@Suite(.serialized)
struct PrimitiveCodableCharacterization {

	@Test
	func edgeCaseStringsSurviveJSONRoundTrip() throws {
		try assertJSONRoundTrip([FHIRDate].self, ["2019", "1973-06", "0001-01-01"])
		try assertJSONRoundTrip([FHIRTime].self, ["09:41:60", "14:15:17.000000"])
		try assertJSONRoundTrip([DateTime].self, ["2014", "2018-01-10T10:31:52-00:00", "2019-02-11T11:32:53.65+04:00"])
		try assertJSONRoundTrip([Instant].self, ["2016-12-31T23:59:60Z", "2017-12-09T09:30:51.000Z"])
	}

	private func assertJSONRoundTrip<T: Codable & CustomStringConvertible>(
		_ type: [T].Type,
		_ strings: [String],
		sourceLocation: SourceLocation = #_sourceLocation
	) throws {
		let json = try JSONEncoder().encode(strings)
		let decoded = try JSONDecoder().decode([T].self, from: json)
		#expect(decoded.map(\.description) == strings, sourceLocation: sourceLocation)
		let reencoded = try JSONEncoder().encode(decoded)
		#expect(reencoded == json, sourceLocation: sourceLocation)
	}
}
