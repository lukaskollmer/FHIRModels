//
//  CrossTargetConsistencyTests.swift
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
import Testing

/*
 The date/time primitive types are maintained as per-target copies rather than living in FMCore.
 The DateTimeTests suites only exercise the ModelsR5 copies, which is sound only as long as every
 target's copy is identical — this test guards that invariant byte-for-byte, across all `Models*`
 targets present in Sources/ (discovered dynamically so a future target is covered automatically).
 (TimeZone and Scanner parsing live once in FMCore and need no such guard.)
 */
@Suite(.serialized)
struct CrossTargetConsistencyTests {

	private static let dateTimeFiles = [
		"FHIRDate.swift", "FHIRTime.swift", "DateTime.swift", "Instant.swift", "InstantDate.swift",
		"FHIRDate+NSDate.swift", "FHIRTime+NSDate.swift", "DateTime+NSDate.swift", "Instant+NSDate.swift",
	]
	private static let referenceTarget = "ModelsR4"

	/// Walks up from this file to the directory containing Package.swift.
	private static func packageRoot() -> URL? {
		var url = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
		while url.path != "/" {
			if FileManager.default.fileExists(atPath: url.appendingPathComponent("Package.swift").path) {
				return url
			}
			url.deleteLastPathComponent()
		}
		return nil
	}

	@Test
	func dateTimeSourceFilesAreIdenticalAcrossTargets() throws {
		guard let packageRoot = Self.packageRoot() else {
			// Source checkout not available (e.g. tests running from a relocated build product); nothing to check.
			return
		}
		let sourcesDirectory = packageRoot.appendingPathComponent("Sources")
		let modelTargets = try FileManager.default
			.contentsOfDirectory(atPath: sourcesDirectory.path)
			.filter { $0.hasPrefix("Models") }
			.sorted()
		#expect(modelTargets.count >= 6, "Expected at least the 6 known model targets, found: \(modelTargets)")
		#expect(modelTargets.contains(Self.referenceTarget))

		for file in Self.dateTimeFiles {
			let reference = try Data(contentsOf: sourcesDirectory
				.appendingPathComponent(Self.referenceTarget)
				.appendingPathComponent(file))
			for target in modelTargets where target != Self.referenceTarget {
				let other = try Data(contentsOf: sourcesDirectory
					.appendingPathComponent(target)
					.appendingPathComponent(file))
				#expect(other == reference, "\(target)/\(file) diverges from \(Self.referenceTarget)/\(file); the copies must stay in sync (or the parsing logic should move to FMCore)")
			}
		}
	}
}
