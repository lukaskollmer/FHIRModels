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
 Value Set for QICore Adverse Event Category (Preferred)
 
 URL: http://hl7.org/fhir/qicore-adverseevent-category
 ValueSet: http://hl7.org/fhir/ValueSet/qicore-adverseevent-category
 */
public indirect enum QICoreAdverseEventCategoryCodes: String, FHIRPrimitiveType {
	
	/// Blood or Blood Product
	case blood
	
	/// Device or Medical/Surgical Supply, including Health Information Technology (HIT)
	case device
	
	/// Venous Thromboembolism
	case embolism
	
	/// Fall by patient
	case fall
	
	/// Healthcare-related infection
	case infection
	
	/// Other (please specify)
	case other
	
	/// Perinatal
	case perinatal
	
	/// Medication or Other Substance
	case substance
	
	/// Surgery or Anesthesia (includes invasive procedures)
	case surgery
	
	/// Pressure Ulcer
	case ulcer
}
