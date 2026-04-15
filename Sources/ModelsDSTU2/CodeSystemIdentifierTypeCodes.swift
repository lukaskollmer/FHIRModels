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
 A coded type for an identifier that can be used to determine which identifier to use for a specific purpose.
 
 URL: http://hl7.org/fhir/identifier-type
 ValueSet: http://hl7.org/fhir/ValueSet/identifier-type
 */
public indirect enum IdentifierTypeCodes: String, FHIRPrimitiveType {
	
	/// The Identifier associated with the person, or service, who produces the observations or fulfills the order
	/// requested by the requestor.
	case FILL
	
	/// The identifier associated with the person or service that requests or places an order.
	case PLAC
	
	/// An identifier issued by a governmental organization to an individual for the purpose of the receipt of social
	/// services and benefits.
	case SB
	
	/// An identifier affixed to an item by the manufacturer when it is first made, where each item has a different
	/// identifier.
	case SNO
	
	/// A identifier assigned to a device using the Universal Device Identifier framework as defined by FDA
	/// (http://www.fda.gov/MedicalDevices/DeviceRegulationandGuidance/UniqueDeviceIdentification/).
	case UDI
}
