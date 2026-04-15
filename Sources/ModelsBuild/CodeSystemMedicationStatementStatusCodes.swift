//
//  CodeSystems.swift
//  HealthRecords
//
//  Generated from FHIR 6.0.0-ballot4
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
 MedicationStatement Status Codes
 
 URL: http://hl7.org/fhir/CodeSystem/medication-statement-status
 ValueSet: http://hl7.org/fhir/ValueSet/medication-statement-status
 */
public indirect enum MedicationStatementStatusCodes: String, FHIRPrimitiveType {
	
	/// The medication usage is draft or preliminary.
	case draft
	
	/// The statement was entered in error and is not valid.
	case enteredInError = "entered-in-error"
	
	/// The action of recording the medication statement is finished.
	case recorded
}
