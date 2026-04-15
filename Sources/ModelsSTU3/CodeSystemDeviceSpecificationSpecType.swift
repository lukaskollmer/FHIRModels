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
 Codes for device specification types such as serial number, part number, hardware revision, software revision, etc.
 
 URL: http://hl7.org/fhir/specification-type
 ValueSet: http://hl7.org/fhir/ValueSet/specification-type
 */
public indirect enum DeviceSpecificationSpecType: String, FHIRPrimitiveType {
	
	/// Firmware Revision - MDC_ID_PROD_SPEC_FW
	case firmwareRevision = "firmware-revision"
	
	/// GMDN - MDC_ID_PROD_SPEC_GMDN
	case gmdn
	
	/// Hardware Revision - MDC_ID_PROD_SPEC_HW
	case hardwareRevision = "hardware-revision"
	
	/// Part Number - MDC_ID_PROD_SPEC_PART
	case partNumber = "part-number"
	
	/// Protocol Revision - MDC_ID_PROD_SPEC_PROTOCOL
	case protocolRevision = "protocol-revision"
	
	/// Serial Number - MDC_ID_PROD_SPEC_SERIAL
	case serialNumber = "serial-number"
	
	/// Software Revision - MDC_ID_PROD_SPEC_SW
	case softwareRevision = "software-revision"
	
	/// Unspecified Production Specification - MDC_ID_PROD_SPEC_UNSPECIFIED
	case unspecified
}
