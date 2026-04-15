//
//  MedicationStatement.swift
//  HealthSoftware
//
//  Generated from FHIR 1.0.2.7202 (http://hl7.org/fhir/StructureDefinition/MedicationStatement)
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
 Record of medication being taken by a patient.
 
 A record of a medication that is being consumed by a patient.   A MedicationStatement may indicate that the patient may
 be taking the medication now, or has taken the medication in the past or will be taking the medication in the future.
 The source of this information can be the patient, significant other (such as a family member or spouse), or a
 clinician.  A common scenario where this information is captured is during the history taking process during a patient
 visit or stay.   The medication information may come from e.g. the patient's memory, from a prescription bottle,  or
 from a list of medications the patient, clinician or other party maintains
 
 The primary difference between a medication statement and a medication administration is that the medication
 administration has complete administration information and is based on actual administration information from the
 person who administered the medication.  A medication statement is often, if not always, less specific.  There is no
 required date/time when the medication was administered, in fact we only know that a source has reported the patient is
 taking this medication, where details such as time, quantity, or rate or even medication product may be incomplete or
 missing or less precise.  As stated earlier, the medication statement information may come from the patient's memory,
 from a prescription bottle or from a list of medications the patient, clinician or other party maintains.  Medication
 administration is more formal and is not missing detailed information.
 */
public struct MedicationStatement: DomainResource {
	
	public static let resourceType: ResourceType = .medicationStatement
	
	/// All possible types for "effective[x]"
	public indirect enum EffectiveX: Equatable, Hashable, Sendable {
		case dateTime(FHIRPrimitive<DateTime>)
		case period(Period)
	}
	
	/// All possible types for "medication[x]"
	public indirect enum MedicationX: Equatable, Hashable, Sendable {
		case codeableConcept(CodeableConcept)
		case reference(Reference)
	}
	
	/// All possible types for "reasonForUse[x]"
	public indirect enum ReasonForUseX: Equatable, Hashable, Sendable {
		case codeableConcept(CodeableConcept)
		case reference(Reference)
	}
	
	/// Contained, inline Resources
	public var contained: [ResourceProxy]?
	
	/// When the statement was asserted?
	public var dateAsserted: FHIRPrimitive<DateTime>?
	
	/// Details of how medication was taken
	public var dosage: [MedicationStatementDosage]?
	
	/// Over what period was medication consumed?
	/// One of `effective[x]`
	public var effective: EffectiveX?
	
	/// Additional Content defined by implementations
	public var `extension`: [Extension]?
	
	/// Logical id of this artifact
	public var id: FHIRPrimitive<FHIRString>?
	
	/// External identifier
	public var identifier: [Identifier]?
	
	/// A set of rules under which this content was created
	public var implicitRules: FHIRPrimitive<FHIRURI>?
	
	/// None
	public var informationSource: Reference?
	
	/// Language of the resource content
	public var language: FHIRPrimitive<FHIRString>?
	
	/// What medication was taken
	/// One of `medication[x]`
	public var medication: MedicationX
	
	/// Metadata about the resource
	public var meta: Meta?
	
	/// Extensions that cannot be ignored
	public var modifierExtension: [Extension]?
	
	/// Further information about the statement
	public var note: FHIRPrimitive<FHIRString>?
	
	/// Who is/was taking  the medication
	public var patient: Reference
	
	/// 
	/// One of `reasonForUse[x]`
	public var reasonForUse: ReasonForUseX?
	
	/// True if asserting medication was not given
	public var reasonNotTaken: [CodeableConcept]?
	
	/// A code representing the patient or other source's judgment about the state of the medication used that this
	/// statement is about.  Generally this will be active or completed.
	/// Restricted to: ['active', 'completed', 'entered-in-error', 'intended']
	public var status: FHIRPrimitive<MedicationStatementStatus>
	
	/// Additional supporting information
	public var supportingInformation: [Reference]?
	
	/// Text summary of the resource, for human interpretation
	public var text: Narrative?
	
	/// True if medication is/was not being taken
	public var wasNotTaken: FHIRPrimitive<FHIRBool>?
	
	/// Designated initializer taking all required properties
	public init(medication: MedicationX, patient: Reference, status: FHIRPrimitive<MedicationStatementStatus>) {
		self.medication = medication
		self.patient = patient
		self.status = status
	}
	
	/// Convenience initializer
	public init(
		contained: [ResourceProxy]? = nil,
		dateAsserted: FHIRPrimitive<DateTime>? = nil,
		dosage: [MedicationStatementDosage]? = nil,
		effective: EffectiveX? = nil,
		`extension`: [Extension]? = nil,
		id: FHIRPrimitive<FHIRString>? = nil,
		identifier: [Identifier]? = nil,
		implicitRules: FHIRPrimitive<FHIRURI>? = nil,
		informationSource: Reference? = nil,
		language: FHIRPrimitive<FHIRString>? = nil,
		medication: MedicationX,
		meta: Meta? = nil,
		modifierExtension: [Extension]? = nil,
		note: FHIRPrimitive<FHIRString>? = nil,
		patient: Reference,
		reasonForUse: ReasonForUseX? = nil,
		reasonNotTaken: [CodeableConcept]? = nil,
		status: FHIRPrimitive<MedicationStatementStatus>,
		supportingInformation: [Reference]? = nil,
		text: Narrative? = nil,
		wasNotTaken: FHIRPrimitive<FHIRBool>? = nil
	) {
		self.init(medication: medication, patient: patient, status: status)
		self.contained = contained
		self.dateAsserted = dateAsserted
		self.dosage = dosage
		self.effective = effective
		self.`extension` = `extension`
		self.id = id
		self.identifier = identifier
		self.implicitRules = implicitRules
		self.informationSource = informationSource
		self.language = language
		self.meta = meta
		self.modifierExtension = modifierExtension
		self.note = note
		self.reasonForUse = reasonForUse
		self.reasonNotTaken = reasonNotTaken
		self.supportingInformation = supportingInformation
		self.text = text
		self.wasNotTaken = wasNotTaken
	}
	
	// MARK: - Codable
	
	private enum CodingKeys: String, CodingKey {
		case resourceType
		case contained
		case dateAsserted; case _dateAsserted
		case dosage
		case effectiveDateTime; case _effectiveDateTime
		case effectivePeriod
		case `extension` = "extension"
		case id; case _id
		case identifier
		case implicitRules; case _implicitRules
		case informationSource
		case language; case _language
		case medicationCodeableConcept
		case medicationReference
		case meta
		case modifierExtension
		case note; case _note
		case patient
		case reasonForUseCodeableConcept
		case reasonForUseReference
		case reasonNotTaken
		case status; case _status
		case supportingInformation
		case text
		case wasNotTaken; case _wasNotTaken
	}

	/// Initializer for Decodable
	public init(from decoder: Decoder) throws {
		let _container = try decoder.container(keyedBy: CodingKeys.self)
		
		// Validate that we have at least one of the mandatory properties for expanded properties
		guard _container.contains(CodingKeys.medicationCodeableConcept) || _container.contains(CodingKeys.medicationReference) else {
			throw DecodingError.valueNotFound(Any.self, DecodingError.Context(codingPath: [CodingKeys.medicationCodeableConcept, CodingKeys.medicationReference], debugDescription: "Must have at least one value for \"medication\" but have none"))
		}
		
		// Decode all our properties (own and inherited)
		self.contained = try [ResourceProxy](from: _container, forKeyIfPresent: .contained)
		self.dateAsserted = try FHIRPrimitive<DateTime>(from: _container, forKeyIfPresent: .dateAsserted, auxiliaryKey: ._dateAsserted)
		self.dosage = try [MedicationStatementDosage](from: _container, forKeyIfPresent: .dosage)
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
		self.effective = _t_effective
		self.`extension` = try [Extension](from: _container, forKeyIfPresent: .`extension`)
		self.id = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .id, auxiliaryKey: ._id)
		self.identifier = try [Identifier](from: _container, forKeyIfPresent: .identifier)
		self.implicitRules = try FHIRPrimitive<FHIRURI>(from: _container, forKeyIfPresent: .implicitRules, auxiliaryKey: ._implicitRules)
		self.informationSource = try Reference(from: _container, forKeyIfPresent: .informationSource)
		self.language = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .language, auxiliaryKey: ._language)
		var _t_medication: MedicationX? = nil
		if let medicationCodeableConcept = try CodeableConcept(from: _container, forKeyIfPresent: .medicationCodeableConcept) {
			if _t_medication != nil {
				throw DecodingError.dataCorruptedError(forKey: .medicationCodeableConcept, in: _container, debugDescription: "More than one value provided for \"medication\"")
			}
			_t_medication = .codeableConcept(medicationCodeableConcept)
		}
		if let medicationReference = try Reference(from: _container, forKeyIfPresent: .medicationReference) {
			if _t_medication != nil {
				throw DecodingError.dataCorruptedError(forKey: .medicationReference, in: _container, debugDescription: "More than one value provided for \"medication\"")
			}
			_t_medication = .reference(medicationReference)
		}
		self.medication = _t_medication!
		self.meta = try Meta(from: _container, forKeyIfPresent: .meta)
		self.modifierExtension = try [Extension](from: _container, forKeyIfPresent: .modifierExtension)
		self.note = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .note, auxiliaryKey: ._note)
		self.patient = try Reference(from: _container, forKey: .patient)
		var _t_reasonForUse: ReasonForUseX? = nil
		if let reasonForUseCodeableConcept = try CodeableConcept(from: _container, forKeyIfPresent: .reasonForUseCodeableConcept) {
			if _t_reasonForUse != nil {
				throw DecodingError.dataCorruptedError(forKey: .reasonForUseCodeableConcept, in: _container, debugDescription: "More than one value provided for \"reasonForUse\"")
			}
			_t_reasonForUse = .codeableConcept(reasonForUseCodeableConcept)
		}
		if let reasonForUseReference = try Reference(from: _container, forKeyIfPresent: .reasonForUseReference) {
			if _t_reasonForUse != nil {
				throw DecodingError.dataCorruptedError(forKey: .reasonForUseReference, in: _container, debugDescription: "More than one value provided for \"reasonForUse\"")
			}
			_t_reasonForUse = .reference(reasonForUseReference)
		}
		self.reasonForUse = _t_reasonForUse
		self.reasonNotTaken = try [CodeableConcept](from: _container, forKeyIfPresent: .reasonNotTaken)
		self.status = try FHIRPrimitive<MedicationStatementStatus>(from: _container, forKey: .status, auxiliaryKey: ._status)
		self.supportingInformation = try [Reference](from: _container, forKeyIfPresent: .supportingInformation)
		self.text = try Narrative(from: _container, forKeyIfPresent: .text)
		self.wasNotTaken = try FHIRPrimitive<FHIRBool>(from: _container, forKeyIfPresent: .wasNotTaken, auxiliaryKey: ._wasNotTaken)
	}
	
	/// Encodable
	public func encode(to encoder: Encoder) throws {
		var _container = encoder.container(keyedBy: CodingKeys.self)
		// Encode resourceType
		try _container.encode(Self.resourceType, forKey: .resourceType)
		// Encode all our properties (own and inherited)
		try contained?.encode(on: &_container, forKey: .contained)
		try dateAsserted?.encode(on: &_container, forKey: .dateAsserted, auxiliaryKey: ._dateAsserted)
		try dosage?.encode(on: &_container, forKey: .dosage)
		if let _enum = effective {
			switch _enum {
			case .dateTime(let _value):
				try _value.encode(on: &_container, forKey: .effectiveDateTime, auxiliaryKey: ._effectiveDateTime)
			case .period(let _value):
				try _value.encode(on: &_container, forKey: .effectivePeriod)
			}
		}
		try `extension`?.encode(on: &_container, forKey: .`extension`)
		try id?.encode(on: &_container, forKey: .id, auxiliaryKey: ._id)
		try identifier?.encode(on: &_container, forKey: .identifier)
		try implicitRules?.encode(on: &_container, forKey: .implicitRules, auxiliaryKey: ._implicitRules)
		try informationSource?.encode(on: &_container, forKey: .informationSource)
		try language?.encode(on: &_container, forKey: .language, auxiliaryKey: ._language)
		
			switch medication {
			case .codeableConcept(let _value):
				try _value.encode(on: &_container, forKey: .medicationCodeableConcept)
			case .reference(let _value):
				try _value.encode(on: &_container, forKey: .medicationReference)
			}
		
		try meta?.encode(on: &_container, forKey: .meta)
		try modifierExtension?.encode(on: &_container, forKey: .modifierExtension)
		try note?.encode(on: &_container, forKey: .note, auxiliaryKey: ._note)
		try patient.encode(on: &_container, forKey: .patient)
		if let _enum = reasonForUse {
			switch _enum {
			case .codeableConcept(let _value):
				try _value.encode(on: &_container, forKey: .reasonForUseCodeableConcept)
			case .reference(let _value):
				try _value.encode(on: &_container, forKey: .reasonForUseReference)
			}
		}
		try reasonNotTaken?.encode(on: &_container, forKey: .reasonNotTaken)
		try status.encode(on: &_container, forKey: .status, auxiliaryKey: ._status)
		try supportingInformation?.encode(on: &_container, forKey: .supportingInformation)
		try text?.encode(on: &_container, forKey: .text)
		try wasNotTaken?.encode(on: &_container, forKey: .wasNotTaken, auxiliaryKey: ._wasNotTaken)
	}
}

/**
 Details of how medication was taken.
 
 Indicates how the medication is/was used by the patient.
 */
public typealias MedicationStatementDosage = BackboneElement
