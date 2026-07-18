//
//  FHIRDecodingDepthTracker.swift
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


extension CodingUserInfoKey {
    fileprivate static let maxFHIRModelsDepthKey = Self(rawValue: "com.apple.health.fhirmodels.maxDecodingDepth")!
}


extension JSONDecoder {

    /// A maximum depth requirement enforced by FHIRModels, if set to a value greater than zero.
    ///
    /// The purpose of this check is to prevent stack exhaustion from recursive structures.
    /// You can either enable this check by setting the ``maxFHIRModelsDepth`` value on a `JSONDecoder` created by your program,
    /// or you can use ``Foundation/JSONDecoder/fhirModelsReadyDecoder(maxDepth:)`` to obtain a `JSONDecoder` with this check enabled.
    ///
    /// A `nil` value, or any value `<= 0` disables the check entirely.
    ///
    /// - Note: "Depth" here does not necessarily relate to the logical decoding descent depth,
    ///     but rather to an opaque depth value that monotonically increases with the decoder descending into the data being decoded.
	public var maxFHIRModelsDepth: Int? {
		get { userInfo[.maxFHIRModelsDepthKey] as? Int }
		set { userInfo[.maxFHIRModelsDepthKey] = newValue }
	}
    
	/// A `JSONDecoder` preconfigured with FHIRModels' recommended decoding-depth limit.
	public static func fhirModelsReadyDecoder(maxDepth: Int = 48) -> JSONDecoder {
		let decoder = JSONDecoder()
		decoder.maxFHIRModelsDepth = maxDepth
		return decoder
	}
}


extension Decoder {
	/// Throws a `DecodingError.dataCorrupted` if the current decoding `codingPath` is deeper than the
	/// limit configured via ``Foundation/JSONDecoder/maxFHIRModelsDepth``. A no-op when no limit is set
	/// (e.g. a plain `JSONDecoder()` with no configuration), or when the decoder does not carry the
	/// FHIRModels depth limit in its `userInfo`.
	///
	/// This should be called at the top of every generated model's `init(from:)`.
	package func enforceFHIRModelsDepthLimit() throws(DecodingError) {
		guard let maxDepth = userInfo[.maxFHIRModelsDepthKey] as? Int, maxDepth > 0,
			  codingPath.count > maxDepth else {
			return
		}
		throw DecodingError.dataCorrupted(DecodingError.Context(
			codingPath: codingPath,
			debugDescription: "Coding path depth \(codingPath.count) exceeds maximum of \(maxDepth)"
		))
	}
}
