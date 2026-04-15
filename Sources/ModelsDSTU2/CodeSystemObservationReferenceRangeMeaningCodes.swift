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
 This value set defines a set of codes that can be used to indicate the meaning/use of a reference range.
 
 URL: http://hl7.org/fhir/referencerange-meaning
 ValueSet: http://hl7.org/fhir/ValueSet/referencerange-meaning
 */
public indirect enum ObservationReferenceRangeMeaningCodes: String, FHIRPrimitiveType {
	
	/// Endocrine related states that change the expected value.
	case endocrine
	
	/// An expected range in an individual during the follicular stage of the cycle.
	case follicular
	
	/// An expected range in an individual during the luteal stage of the cycle.
	case luteal
	
	/// An expected range in an individual during the follicular stage of the cycle.
	case midcycle
	
	/// Based on 95th percentile for the relevant control population.
	case normal
	
	/// The optimal range for best therapeutic outcomes for a specimen taken immediately after administration.
	case post
	
	/// An expected range in an individual post-menopause.
	case postmeopausal
	
	/// The optimal range for best therapeutic outcomes for a specimen taken immediately before administration.
	case pre
	
	/// An expected range in an individual prior to puberty.
	case prePuberty = "pre-puberty"
	
	/// The range that is recommended by a relevant professional body.
	case recommended
	
	/// The optimal range for best therapeutic outcomes.
	case therapeutic
	
	/// The range at which treatment would/should be considered.
	case treatment
	
	/// General types of reference range.
	case type
}
