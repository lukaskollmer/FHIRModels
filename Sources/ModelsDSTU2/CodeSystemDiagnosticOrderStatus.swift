//
//  CodeSystems.swift
//  HealthRecords
//
//  Generated from FHIR 1.0.2.7202
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

/**
 The status of a diagnostic order.
 
 URL: http://hl7.org/fhir/diagnostic-order-status
 ValueSet: http://hl7.org/fhir/ValueSet/diagnostic-order-status
 */
public indirect enum DiagnosticOrderStatus: String, FHIRPrimitiveType {
	
	/// The receiving system has accepted the order, but work has not yet commenced.
	case accepted
	
	/// The request has been withdrawn.
	case cancelled
	
	/// The work has been completed, the report(s) released, and no further work is planned.
	case completed
	
	/// The request is in preliminary form prior to being sent.
	case draft
	
	/// The diagnostic investigation was attempted, but due to some procedural error, it could not be completed.
	case failed
	
	/// The work to fulfill the order is happening.
	case inProgress = "in-progress"
	
	/// The request has been planned.
	case planned
	
	/// The request has been proposed.
	case proposed
	
	/// The receiving system has received the order, but not yet decided whether it will be performed.
	case received
	
	/// The receiving system has declined to fulfill the request.
	case rejected
	
	/// The request has been placed.
	case requested
	
	/// The work is complete, and the outcomes are being reviewed for approval.
	case review
	
	/// The request has been held by originating system/user request.
	case suspended
}
