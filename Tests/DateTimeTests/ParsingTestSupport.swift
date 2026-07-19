//
//  ParsingTestSupport.swift
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
import struct ModelsR4.FHIRTime
import Testing

/// The FHIR date/time primitives are `ExpressibleByStringLiteral`, and Swift resolves `T("some literal")`
/// through the literal conformance — whose `init(stringLiteral:)` force-tries and would trap on a parse
/// failure — instead of the throwing `init(_: String)`. Routing all parsing through this protocol
/// guarantees the throwing initializer is the one being exercised.
protocol ThrowingStringParseable {
	init(_ string: String) throws
}

extension ModelsR5.FHIRDate: ThrowingStringParseable {}
extension ModelsR5.DateTime: ThrowingStringParseable {}
extension ModelsR5.Instant: ThrowingStringParseable {}
extension ModelsR5.InstantDate: ThrowingStringParseable {}
extension ModelsR5.FHIRTime: ThrowingStringParseable {}
extension ModelsR4.FHIRTime: ThrowingStringParseable {}
extension Foundation.TimeZone: ThrowingStringParseable {
    init(_ string: String) throws {
        try self.init(fhirTimeZoneString: string)
    }
}


func parseFHIR<T: ThrowingStringParseable>(_ string: String, as type: T.Type) throws -> T {
	try T(string)
}


/// Asserts that parsing the string throws the exact `FHIRDateParserError` (case and position).
func expectParseError<T: ThrowingStringParseable>(
	parsing string: String,
	as type: T.Type,
	sourceLocation: SourceLocation = #_sourceLocation
) {
    #expect(throws: (any Error).self, sourceLocation: sourceLocation) {
        try T(string)
    }
}

/// Asserts that parsing the string throws *some* `FHIRDateParserError`, without pinning the case or
/// position. Used where the exact error shape is an artifact of the current implementation (and would
/// change under a legitimate replacement parser), but a clean, typed failure is the actual contract.
func expectCleanParserError<T: ThrowingStringParseable>(
	parsing string: String,
	as type: T.Type,
	sourceLocation: SourceLocation = #_sourceLocation
) {
	#expect(throws: FHIRDateParserError.self, sourceLocation: sourceLocation) {
		try T(string)
	}
}

func position(_ string: String, _ location: Int) -> FHIRDateParserErrorPosition {
	FHIRDateParserErrorPosition(string: string, location: location)
}
