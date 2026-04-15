//
//  DiagnosticReport.swift
//  HealthSoftware
//
//  Generated from FHIR 1.0.2.7202 (http://hl7.org/fhir/StructureDefinition/DiagnosticReport)
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
 A Diagnostic report - a combination of request information, atomic results, images, interpretation, as well as
 formatted reports.
 
 The findings and interpretation of diagnostic  tests performed on patients, groups of patients, devices, and locations,
 and/or specimens derived from these. The report includes clinical context such as requesting and provider information,
 and some mix of atomic results, images, textual and coded interpretations, and formatted representation of diagnostic
 reports.
 */
public struct DiagnosticReport: DomainResource {
	
	public static let resourceType: ResourceType = .diagnosticReport
	
	/// All possible types for "effective[x]"
	public indirect enum EffectiveX: Equatable, Hashable, Sendable {
		case dateTime(FHIRPrimitive<DateTime>)
		case period(Period)
	}
	
	/// Service category
	public var category: CodeableConcept?
	
	/// Name/Code for this diagnostic report
	public var code: CodeableConcept
	
	/// Codes for the conclusion
	public var codedDiagnosis: [CodeableConcept]?
	
	/// Clinical Interpretation of test results
	public var conclusion: FHIRPrimitive<FHIRString>?
	
	/// Contained, inline Resources
	public var contained: [ResourceProxy]?
	
	/// Clinically Relevant time/time-period for report
	/// One of `effective[x]`
	public var effective: EffectiveX
	
	/// Health care event when test ordered
	public var encounter: Reference?
	
	/// Additional Content defined by implementations
	public var `extension`: [Extension]?
	
	/// Logical id of this artifact
	public var id: FHIRPrimitive<FHIRString>?
	
	/// Id for external references to this report
	public var identifier: [Identifier]?
	
	/// Key images associated with this report
	public var image: [DiagnosticReportImage]?
	
	/// Reference to full details of imaging associated with the diagnostic report
	public var imagingStudy: [Reference]?
	
	/// A set of rules under which this content was created
	public var implicitRules: FHIRPrimitive<FHIRURI>?
	
	/// DateTime this version was released
	public var issued: FHIRPrimitive<Instant>
	
	/// Language of the resource content
	public var language: FHIRPrimitive<FHIRString>?
	
	/// Metadata about the resource
	public var meta: Meta?
	
	/// Extensions that cannot be ignored
	public var modifierExtension: [Extension]?
	
	/// Responsible Diagnostic Service
	public var performer: Reference
	
	/// Entire report as issued
	public var presentedForm: [Attachment]?
	
	/// What was requested
	public var request: [Reference]?
	
	/// Observations - simple, or complex nested groups
	public var result: [Reference]?
	
	/// Specimens this report is based on
	public var specimen: [Reference]?
	
	/// The status of the diagnostic report as a whole.
	/// Restricted to: ['registered', 'partial', 'final', 'corrected', 'appended', 'cancelled', 'entered-in-error']
	public var status: FHIRPrimitive<DiagnosticReportStatus>
	
	/// The subject of the report, usually, but not always, the patient
	public var subject: Reference
	
	/// Text summary of the resource, for human interpretation
	public var text: Narrative?
	
	/// Designated initializer taking all required properties
	public init(code: CodeableConcept, effective: EffectiveX, issued: FHIRPrimitive<Instant>, performer: Reference, status: FHIRPrimitive<DiagnosticReportStatus>, subject: Reference) {
		self.code = code
		self.effective = effective
		self.issued = issued
		self.performer = performer
		self.status = status
		self.subject = subject
	}
	
	/// Convenience initializer
	public init(
		category: CodeableConcept? = nil,
		code: CodeableConcept,
		codedDiagnosis: [CodeableConcept]? = nil,
		conclusion: FHIRPrimitive<FHIRString>? = nil,
		contained: [ResourceProxy]? = nil,
		effective: EffectiveX,
		encounter: Reference? = nil,
		`extension`: [Extension]? = nil,
		id: FHIRPrimitive<FHIRString>? = nil,
		identifier: [Identifier]? = nil,
		image: [DiagnosticReportImage]? = nil,
		imagingStudy: [Reference]? = nil,
		implicitRules: FHIRPrimitive<FHIRURI>? = nil,
		issued: FHIRPrimitive<Instant>,
		language: FHIRPrimitive<FHIRString>? = nil,
		meta: Meta? = nil,
		modifierExtension: [Extension]? = nil,
		performer: Reference,
		presentedForm: [Attachment]? = nil,
		request: [Reference]? = nil,
		result: [Reference]? = nil,
		specimen: [Reference]? = nil,
		status: FHIRPrimitive<DiagnosticReportStatus>,
		subject: Reference,
		text: Narrative? = nil
	) {
		self.init(code: code, effective: effective, issued: issued, performer: performer, status: status, subject: subject)
		self.category = category
		self.codedDiagnosis = codedDiagnosis
		self.conclusion = conclusion
		self.contained = contained
		self.encounter = encounter
		self.`extension` = `extension`
		self.id = id
		self.identifier = identifier
		self.image = image
		self.imagingStudy = imagingStudy
		self.implicitRules = implicitRules
		self.language = language
		self.meta = meta
		self.modifierExtension = modifierExtension
		self.presentedForm = presentedForm
		self.request = request
		self.result = result
		self.specimen = specimen
		self.text = text
	}
	
	// MARK: - Codable
	
	private enum CodingKeys: String, CodingKey {
		case resourceType
		case category
		case code
		case codedDiagnosis
		case conclusion; case _conclusion
		case contained
		case effectiveDateTime; case _effectiveDateTime
		case effectivePeriod
		case encounter
		case `extension` = "extension"
		case id; case _id
		case identifier
		case image
		case imagingStudy
		case implicitRules; case _implicitRules
		case issued; case _issued
		case language; case _language
		case meta
		case modifierExtension
		case performer
		case presentedForm
		case request
		case result
		case specimen
		case status; case _status
		case subject
		case text
	}

	/// Initializer for Decodable
	public init(from decoder: Decoder) throws {
		let _container = try decoder.container(keyedBy: CodingKeys.self)
		
		// Validate that we have at least one of the mandatory properties for expanded properties
		guard _container.contains(CodingKeys.effectiveDateTime) || _container.contains(CodingKeys.effectivePeriod) else {
			throw DecodingError.valueNotFound(Any.self, DecodingError.Context(codingPath: [CodingKeys.effectiveDateTime, CodingKeys.effectivePeriod], debugDescription: "Must have at least one value for \"effective\" but have none"))
		}
		
		// Decode all our properties (own and inherited)
		self.category = try CodeableConcept(from: _container, forKeyIfPresent: .category)
		self.code = try CodeableConcept(from: _container, forKey: .code)
		self.codedDiagnosis = try [CodeableConcept](from: _container, forKeyIfPresent: .codedDiagnosis)
		self.conclusion = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .conclusion, auxiliaryKey: ._conclusion)
		self.contained = try [ResourceProxy](from: _container, forKeyIfPresent: .contained)
		var _t_effective: EffectiveX? = nil
		if let effectiveDateTime = try FHIRPrimitive<DateTime>(from: _container, forKeyIfPresent: .effectiveDateTime, auxiliaryKey: ._effectiveDateTime) {
			if _t_effective != nil {
				throw DecodingError.dataCorruptedError(forKey: .effectiveDateTime, in: _container, debugDescription: "More than one value provided for \"effective\"")
			}
			_t_effective = .dateTime(effectiveDateTime)
		}
		if let effectivePeriod = try Period(from: _container, forKeyIfPresent: .effectivePeriod) {
			if _t_effective != nil {
				throw DecodingError.dataCorruptedError(forKey: .effectivePeriod, in: _container, debugDescription: "More than one value provided for \"effective\"")
			}
			_t_effective = .period(effectivePeriod)
		}
		self.effective = _t_effective!
		self.encounter = try Reference(from: _container, forKeyIfPresent: .encounter)
		self.`extension` = try [Extension](from: _container, forKeyIfPresent: .`extension`)
		self.id = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .id, auxiliaryKey: ._id)
		self.identifier = try [Identifier](from: _container, forKeyIfPresent: .identifier)
		self.image = try [DiagnosticReportImage](from: _container, forKeyIfPresent: .image)
		self.imagingStudy = try [Reference](from: _container, forKeyIfPresent: .imagingStudy)
		self.implicitRules = try FHIRPrimitive<FHIRURI>(from: _container, forKeyIfPresent: .implicitRules, auxiliaryKey: ._implicitRules)
		self.issued = try FHIRPrimitive<Instant>(from: _container, forKey: .issued, auxiliaryKey: ._issued)
		self.language = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .language, auxiliaryKey: ._language)
		self.meta = try Meta(from: _container, forKeyIfPresent: .meta)
		self.modifierExtension = try [Extension](from: _container, forKeyIfPresent: .modifierExtension)
		self.performer = try Reference(from: _container, forKey: .performer)
		self.presentedForm = try [Attachment](from: _container, forKeyIfPresent: .presentedForm)
		self.request = try [Reference](from: _container, forKeyIfPresent: .request)
		self.result = try [Reference](from: _container, forKeyIfPresent: .result)
		self.specimen = try [Reference](from: _container, forKeyIfPresent: .specimen)
		self.status = try FHIRPrimitive<DiagnosticReportStatus>(from: _container, forKey: .status, auxiliaryKey: ._status)
		self.subject = try Reference(from: _container, forKey: .subject)
		self.text = try Narrative(from: _container, forKeyIfPresent: .text)
	}
	
	/// Encodable
	public func encode(to encoder: Encoder) throws {
		var _container = encoder.container(keyedBy: CodingKeys.self)
		// Encode resourceType
		try _container.encode(Self.resourceType, forKey: .resourceType)
		// Encode all our properties (own and inherited)
		try category?.encode(on: &_container, forKey: .category)
		try code.encode(on: &_container, forKey: .code)
		try codedDiagnosis?.encode(on: &_container, forKey: .codedDiagnosis)
		try conclusion?.encode(on: &_container, forKey: .conclusion, auxiliaryKey: ._conclusion)
		try contained?.encode(on: &_container, forKey: .contained)
		
			switch effective {
			case .dateTime(let _value):
				try _value.encode(on: &_container, forKey: .effectiveDateTime, auxiliaryKey: ._effectiveDateTime)
			case .period(let _value):
				try _value.encode(on: &_container, forKey: .effectivePeriod)
			}
		
		try encounter?.encode(on: &_container, forKey: .encounter)
		try `extension`?.encode(on: &_container, forKey: .`extension`)
		try id?.encode(on: &_container, forKey: .id, auxiliaryKey: ._id)
		try identifier?.encode(on: &_container, forKey: .identifier)
		try image?.encode(on: &_container, forKey: .image)
		try imagingStudy?.encode(on: &_container, forKey: .imagingStudy)
		try implicitRules?.encode(on: &_container, forKey: .implicitRules, auxiliaryKey: ._implicitRules)
		try issued.encode(on: &_container, forKey: .issued, auxiliaryKey: ._issued)
		try language?.encode(on: &_container, forKey: .language, auxiliaryKey: ._language)
		try meta?.encode(on: &_container, forKey: .meta)
		try modifierExtension?.encode(on: &_container, forKey: .modifierExtension)
		try performer.encode(on: &_container, forKey: .performer)
		try presentedForm?.encode(on: &_container, forKey: .presentedForm)
		try request?.encode(on: &_container, forKey: .request)
		try result?.encode(on: &_container, forKey: .result)
		try specimen?.encode(on: &_container, forKey: .specimen)
		try status.encode(on: &_container, forKey: .status, auxiliaryKey: ._status)
		try subject.encode(on: &_container, forKey: .subject)
		try text?.encode(on: &_container, forKey: .text)
	}
}

/**
 Key images associated with this report.
 
 A list of key images associated with this report. The images are generally created during the diagnostic process, and
 may be directly of the patient, or of treated specimens (i.e. slides of interest).
 */
public typealias DiagnosticReportImage = BackboneElement
