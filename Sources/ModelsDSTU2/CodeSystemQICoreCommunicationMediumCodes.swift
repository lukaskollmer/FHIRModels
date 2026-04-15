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
 Value Set for QICore Communication Medium (Example)
 
 URL: http://hl7.org/fhir/qicore-communication-medium
 ValueSet: http://hl7.org/fhir/ValueSet/qicore-communication-medium
 */
public indirect enum QICoreCommunicationMediumCodes: String, FHIRPrimitiveType {
	
	/// The message was communicated via a medical device
	case device
	
	/// The message was sent as an email
	case email
	
	/// The message was sent via a fax transmission
	case fax
	
	/// The message was communicated in person
	case inPerson = "in-person"
	
	/// The message was posted via conventional mail
	case mail
	
	/// The message was communicated via a patient portal
	case portal
	
	/// The message was communicated via a social media platform
	case socialMedia = "social-media"
	
	/// The message was communicated via telephone
	case telephone
	
	/// The message was sent via text message (SMS)
	case text
	
	/// The communication medium has not been specified
	case unspecified
	
	/// The message was communicated via a video call
	case video
	
	/// The message was left on the recipient's voicemail system
	case voicemail
}
