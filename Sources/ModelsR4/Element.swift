//
//  Element.swift
//  HealthSoftware
//
//  Generated from FHIR 4.0.1-9346c8cc45 (http://hl7.org/fhir/StructureDefinition/Element)
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
 Base for all elements.
 
 Base definition for all elements in a resource.
 */
public protocol ElementReadOnly: FHIRType {
	
	/// Additional content defined by implementations
	var `extension`: [Extension]? { get }
	
	/// Unique id for inter-element referencing
	var id: FHIRPrimitive<FHIRString>? { get }
}

public protocol Element: ElementReadOnly, _FHIRTypeWithExtensions {
	
	/// Additional content defined by implementations
	var `extension`: [Extension]? { get set }
	
	/// Unique id for inter-element referencing
	var id: FHIRPrimitive<FHIRString>? { get set }
}
