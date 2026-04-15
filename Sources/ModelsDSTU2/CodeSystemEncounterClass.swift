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
 Classification of the encounter
 
 URL: http://hl7.org/fhir/encounter-class
 ValueSet: http://hl7.org/fhir/ValueSet/encounter-class
 */
public indirect enum EncounterClass: String, FHIRPrimitiveType {
	
	/// An encounter where the patient visits the practitioner in his/her office, e.g. a G.P. visit.
	case ambulatory
	
	/// An encounter where the patient needs more prolonged treatment or investigations than outpatients, but who do not
	/// need to stay in the hospital overnight.
	case daytime
	
	/// An encounter in the Emergency Care Department.
	case emergency
	
	/// An encounter taking place outside the regular environment for giving care.
	case field
	
	/// An encounter where the practitioner visits the patient at his/her home.
	case home
	
	/// An encounter during which the patient is hospitalized and stays overnight.
	case inpatient
	
	/// Any other encounter type that is not described by one of the other values. Where this is used it is expected
	/// that an implementer will include an extension value to define what the actual other type is.
	case other
	
	/// An encounter during which the patient is not hospitalized overnight.
	case outpatient
	
	/// An encounter that takes place where the patient and practitioner do not physically meet but use electronic means
	/// for contact.
	case virtual
}
