//
//  CodeSystems.swift
//  HealthRecords
//
//  Generated from FHIR 3.0.2.11917
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
 Used to specify why the normally expected content of the data element is missing.
 
 URL: http://hl7.org/fhir/data-absent-reason
 ValueSet: http://hl7.org/fhir/ValueSet/data-absent-reason
 */
public indirect enum DataAbsentReason: String, FHIRPrimitiveType {
	
	/// The source human does not know the value.
	case asked
	
	/// The content of the data is represented in the resource narrative.
	case astext
	
	/// Some system or workflow process error means that the information is not available.
	case error
	
	/// The information is not available due to security, privacy or related reasons.
	case masked
	
	/// NaN, standing for not a number, is a numeric data type value representing an undefined or unrepresentable value.
	case naN = "NaN"
	
	/// The workflow didn't lead to this value being known.
	case notAsked = "not-asked"
	
	/// The value is not available because the observation procedure (test, etc.) was not performed.
	case notPerformed = "not-performed"
	
	/// There is reason to expect (from the workflow) that the value may become known.
	case temp
	
	/// The value is not known.
	case unknown
	
	/// The source system wasn't capable of supporting this element.
	case unsupported
}
