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
 The expected format of an answer.
 
 URL: http://hl7.org/fhir/answer-format
 ValueSet: http://hl7.org/fhir/ValueSet/answer-format
 */
public indirect enum AnswerFormat: String, FHIRPrimitiveType {
	
	/// Answer is binary content such as a image, PDF, etc.
	case attachment
	
	/// Answer is a yes/no answer.
	case boolean
	
	/// Answer is a Coding drawn from a list of options.
	case choice
	
	/// Answer is a date.
	case date
	
	/// Answer is a date and time.
	case dateTime
	
	/// Answer is a floating point number.
	case decimal
	
	/// Answer is a system timestamp.
	case instant
	
	/// Answer is an integer.
	case integer
	
	/// Answer is a Coding drawn from a list of options or a free-text entry.
	case openChoice = "open-choice"
	
	/// Answer is a combination of a numeric value and unit, potentially with a comparator (<, >, etc.).
	case quantity
	
	/// Answer is a reference to another resource (practitioner, organization, etc.).
	case reference
	
	/// Answer is a short (few words to short sentence) free-text entry.
	case string
	
	/// Answer is a long (potentially multi-paragraph) free-text entry (still captured as a string).
	case text
	
	/// Answer is a time (hour/minute/second) independent of date.
	case time
	
	/// Answer is a url (website, FTP site, etc.).
	case url
}
