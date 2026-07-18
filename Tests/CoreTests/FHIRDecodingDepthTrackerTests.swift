//
//  FHIRDecodingDepthTrackerTests.swift
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

struct FHIRDecodingDepthTrackerTests {

	// `nestedExtensionJSON(depth: 50)` nests 50 `Extension`s, each reached via the `extension`
	// key plus an array index, so the deepest model decodes at codingPath depth 2 * 50 = 100.
	// The limit is therefore honoured at codingPath-unit boundaries around 100, not 50.
	@Test(arguments: [
		(   1, true),
		(  50, true),
		(  99, true),
		( 100, false),
		( 200, false),
	])
	func respectsDecodingDepth(maxDepth: Int, shouldThrow: Bool) throws {
		let decoder = JSONDecoder()
		decoder.maxFHIRModelsDepth = maxDepth

		let data = try #require(nestedExtensionJSON(depth: 50).data(using: .utf8))
		do {
			_ = try decoder.decode(Patient.self, from: data)
			#expect(!shouldThrow, "Should have thrown for a maximum of \(maxDepth) but didn't")
		} catch let error as DecodingError {
			#expect(shouldThrow, "Threw «\(error)» but should not have thrown for a maximum of \(maxDepth)")
		}
	}

	@Test
	func verifyProductionDecoderSetup() throws {
		let decoder = JSONDecoder.fhirModelsReadyDecoder()
		#expect(decoder.maxFHIRModelsDepth == 48)
	}

	@Test
	func productionDecoderHonoursCustomLimit() throws {
		let decoder = JSONDecoder.fhirModelsReadyDecoder(maxDepth: 12)
		#expect(decoder.maxFHIRModelsDepth == 12)
	}

	@Test
	func unsetLimitDisablesEnforcement() throws {
		let decoder = JSONDecoder() // no limit configured
		#expect(decoder.maxFHIRModelsDepth == nil)
		let data = try #require(nestedExtensionJSON(depth: 50).data(using: .utf8))
		#expect(throws: Never.self) {
			try decoder.decode(Patient.self, from: data)
		}
	}

	/// A broad-but-shallow document must never be rejected: 500 sibling extensions have a true
	/// nesting depth of 2, so the depth guard must not accumulate across siblings.
	@Test
	func wideDocumentIsNotRejected() throws {
		let decoder = JSONDecoder.fhirModelsReadyDecoder()
		let siblings = (0 ..< 500).map { #"{"url":"\#($0)","valueString":"v"}"# }.joined(separator: ",")
		let json = #"{"resourceType":"Patient","extension":[\#(siblings)]}"#
		let data = try #require(json.data(using: .utf8))
		#expect(throws: Never.self) {
			try decoder.decode(Patient.self, from: data)
		}
	}

	/// Regression test for the shared-mutable-counter bug: one `fhirModelsReadyDecoder` reused
	/// across many concurrent decodes of a valid, in-limit document must never spuriously throw.
	@Test
	func concurrentDecodesOnSharedDecoderSucceed() async throws {
		let decoder = JSONDecoder.fhirModelsReadyDecoder()
		let data = try #require(nestedExtensionJSON(depth: 8).data(using: .utf8)) // codingPath depth 16, well under 48
		try await withThrowingTaskGroup(of: Void.self) { group in
			for _ in 0 ..< 200 {
				group.addTask {
					_ = try decoder.decode(Patient.self, from: data)
				}
			}
			try await group.waitForAll()
		}
	}

	// MARK: - Utilities

	/**
	 Builds a Patient JSON string with `depth` levels of nested `Extension`.

	     {
	        "resourceType": "Patient",
	        "extension": [{
	             "url": "1",
	             "extension": [{
	                 "url": "2",
	                 "extension": [ ... ]
	             }]
	         }]
	     }
	 */
	private func nestedExtensionJSON(depth: Int) -> String {
		var content = #"{"url":"\#(depth - 1)","valueString":"At depth \#(depth - 1)"}"#
		for level in stride(from: depth - 2, through: 0, by: -1) {
			content = #"{"url":"\#(level)","extension":[\#(content)]}"#
		}
		return #"{"resourceType":"Patient","extension":[\#(content)]}"#
	}
}
