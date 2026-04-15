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
 The status of the response to an order.
 
 URL: http://hl7.org/fhir/order-status
 ValueSet: http://hl7.org/fhir/ValueSet/order-status
 */
public indirect enum OrderStatus: String, FHIRPrimitiveType {
	
	/// Processing the order was stopped because of some workflow/business logic reason.
	case aborted
	
	/// The order has been accepted, and work is in progress.
	case accepted
	
	/// Processing the order was halted at the initiators request.
	case cancelled
	
	/// The order has been completed.
	case completed
	
	/// The order was unable to be processed because of a technical error (i.e. unexpected error)
	case error
	
	/// The order is known, but no processing has occurred at this time
	case pending
	
	/// The order was rejected because of a workflow/business logic reason
	case rejected
	
	/// The order has been cancelled and replaced by another.
	case replaced
	
	/// The order is undergoing initial processing to determine whether it will be accepted (usually this involves human
	/// review)
	case review
}
