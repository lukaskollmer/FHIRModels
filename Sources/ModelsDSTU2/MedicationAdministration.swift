//
//  MedicationAdministration.swift
//  HealthSoftware
//
//  Generated from FHIR 1.0.2.7202 (http://hl7.org/fhir/StructureDefinition/MedicationAdministration)
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
 Administration of medication to a patient.
 
 Describes the event of a patient consuming or otherwise being administered a medication.  This may be as simple as
 swallowing a tablet or it may be a long running infusion.  Related resources tie this event to the authorizing
 prescription, and the specific encounter between patient and health care practitioner.
 */
public struct MedicationAdministration: DomainResource {
	
	public static let resourceType: ResourceType = .medicationAdministration
	
	/// All possible types for "effectiveTime[x]"
	public indirect enum EffectiveTimeX: Equatable, Hashable, Sendable {
		case dateTime(FHIRPrimitive<DateTime>)
		case period(Period)
	}
	
	/// All possible types for "medication[x]"
	public indirect enum MedicationX: Equatable, Hashable, Sendable {
		case codeableConcept(CodeableConcept)
		case reference(Reference)
	}
	
	/// Contained, inline Resources
	public var contained: [ResourceProxy]?
	
	/// Device used to administer
	public var device: [Reference]?
	
	/// Details of how medication was taken
	public var dosage: MedicationAdministrationDosage?
	
	/// Start and end time of administration
	/// One of `effectiveTime[x]`
	public var effectiveTime: EffectiveTimeX
	
	/// Encounter administered as part of
	public var encounter: Reference?
	
	/// Additional Content defined by implementations
	public var `extension`: [Extension]?
	
	/// Logical id of this artifact
	public var id: FHIRPrimitive<FHIRString>?
	
	/// External identifier
	public var identifier: [Identifier]?
	
	/// A set of rules under which this content was created
	public var implicitRules: FHIRPrimitive<FHIRURI>?
	
	/// Language of the resource content
	public var language: FHIRPrimitive<FHIRString>?
	
	/// What was administered
	/// One of `medication[x]`
	public var medication: MedicationX
	
	/// Metadata about the resource
	public var meta: Meta?
	
	/// Extensions that cannot be ignored
	public var modifierExtension: [Extension]?
	
	/// Information about the administration
	public var note: FHIRPrimitive<FHIRString>?
	
	/// Who received medication
	public var patient: Reference
	
	/// Who administered substance
	public var practitioner: Reference?
	
	/// Order administration performed against
	public var prescription: Reference?
	
	/// Reason administration performed
	public var reasonGiven: [CodeableConcept]?
	
	/// Reason administration not performed
	public var reasonNotGiven: [CodeableConcept]?
	
	/// Will generally be set to show that the administration has been completed.  For some long running administrations
	/// such as infusions it is possible for an administration to be started but not completed or it may be paused while
	/// some other process is under way.
	/// Restricted to: ['in-progress', 'on-hold', 'completed', 'entered-in-error', 'stopped']
	public var status: FHIRPrimitive<MedicationAdministrationStatus>
	
	/// Text summary of the resource, for human interpretation
	public var text: Narrative?
	
	/// True if medication not administered
	public var wasNotGiven: FHIRPrimitive<FHIRBool>?
	
	/// Designated initializer taking all required properties
	public init(effectiveTime: EffectiveTimeX, medication: MedicationX, patient: Reference, status: FHIRPrimitive<MedicationAdministrationStatus>) {
		self.effectiveTime = effectiveTime
		self.medication = medication
		self.patient = patient
		self.status = status
	}
	
	/// Convenience initializer
	public init(
		contained: [ResourceProxy]? = nil,
		device: [Reference]? = nil,
		dosage: MedicationAdministrationDosage? = nil,
		effectiveTime: EffectiveTimeX,
		encounter: Reference? = nil,
		`extension`: [Extension]? = nil,
		id: FHIRPrimitive<FHIRString>? = nil,
		identifier: [Identifier]? = nil,
		implicitRules: FHIRPrimitive<FHIRURI>? = nil,
		language: FHIRPrimitive<FHIRString>? = nil,
		medication: MedicationX,
		meta: Meta? = nil,
		modifierExtension: [Extension]? = nil,
		note: FHIRPrimitive<FHIRString>? = nil,
		patient: Reference,
		practitioner: Reference? = nil,
		prescription: Reference? = nil,
		reasonGiven: [CodeableConcept]? = nil,
		reasonNotGiven: [CodeableConcept]? = nil,
		status: FHIRPrimitive<MedicationAdministrationStatus>,
		text: Narrative? = nil,
		wasNotGiven: FHIRPrimitive<FHIRBool>? = nil
	) {
		self.init(effectiveTime: effectiveTime, medication: medication, patient: patient, status: status)
		self.contained = contained
		self.device = device
		self.dosage = dosage
		self.encounter = encounter
		self.`extension` = `extension`
		self.id = id
		self.identifier = identifier
		self.implicitRules = implicitRules
		self.language = language
		self.meta = meta
		self.modifierExtension = modifierExtension
		self.note = note
		self.practitioner = practitioner
		self.prescription = prescription
		self.reasonGiven = reasonGiven
		self.reasonNotGiven = reasonNotGiven
		self.text = text
		self.wasNotGiven = wasNotGiven
	}
	
	// MARK: - Codable
	
	private enum CodingKeys: String, CodingKey {
		case resourceType
		case contained
		case device
		case dosage
		case effectiveTimeDateTime; case _effectiveTimeDateTime
		case effectiveTimePeriod
		case encounter
		case `extension` = "extension"
		case id; case _id
		case identifier
		case implicitRules; case _implicitRules
		case language; case _language
		case medicationCodeableConcept
		case medicationReference
		case meta
		case modifierExtension
		case note; case _note
		case patient
		case practitioner
		case prescription
		case reasonGiven
		case reasonNotGiven
		case status; case _status
		case text
		case wasNotGiven; case _wasNotGiven
	}

	/// Initializer for Decodable
	public init(from decoder: Decoder) throws {
		let _container = try decoder.container(keyedBy: CodingKeys.self)
		
		// Validate that we have at least one of the mandatory properties for expanded properties
		guard _container.contains(CodingKeys.effectiveTimeDateTime) || _container.contains(CodingKeys.effectiveTimePeriod) else {
			throw DecodingError.valueNotFound(Any.self, DecodingError.Context(codingPath: [CodingKeys.effectiveTimeDateTime, CodingKeys.effectiveTimePeriod], debugDescription: "Must have at least one value for \"effectiveTime\" but have none"))
		}
		guard _container.contains(CodingKeys.medicationCodeableConcept) || _container.contains(CodingKeys.medicationReference) else {
			throw DecodingError.valueNotFound(Any.self, DecodingError.Context(codingPath: [CodingKeys.medicationCodeableConcept, CodingKeys.medicationReference], debugDescription: "Must have at least one value for \"medication\" but have none"))
		}
		
		// Decode all our properties (own and inherited)
		self.contained = try [ResourceProxy](from: _container, forKeyIfPresent: .contained)
		self.device = try [Reference](from: _container, forKeyIfPresent: .device)
		self.dosage = try MedicationAdministrationDosage(from: _container, forKeyIfPresent: .dosage)
		var _t_effectiveTime: EffectiveTimeX? = nil
		if let effectiveTimeDateTime = try FHIRPrimitive<DateTime>(from: _container, forKeyIfPresent: .effectiveTimeDateTime, auxiliaryKey: ._effectiveTimeDateTime) {
			if _t_effectiveTime != nil {
				throw DecodingError.dataCorruptedError(forKey: .effectiveTimeDateTime, in: _container, debugDescription: "More than one value provided for \"effectiveTime\"")
			}
			_t_effectiveTime = .dateTime(effectiveTimeDateTime)
		}
		if let effectiveTimePeriod = try Period(from: _container, forKeyIfPresent: .effectiveTimePeriod) {
			if _t_effectiveTime != nil {
				throw DecodingError.dataCorruptedError(forKey: .effectiveTimePeriod, in: _container, debugDescription: "More than one value provided for \"effectiveTime\"")
			}
			_t_effectiveTime = .period(effectiveTimePeriod)
		}
		self.effectiveTime = _t_effectiveTime!
		self.encounter = try Reference(from: _container, forKeyIfPresent: .encounter)
		self.`extension` = try [Extension](from: _container, forKeyIfPresent: .`extension`)
		self.id = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .id, auxiliaryKey: ._id)
		self.identifier = try [Identifier](from: _container, forKeyIfPresent: .identifier)
		self.implicitRules = try FHIRPrimitive<FHIRURI>(from: _container, forKeyIfPresent: .implicitRules, auxiliaryKey: ._implicitRules)
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
		self.practitioner = try Reference(from: _container, forKeyIfPresent: .practitioner)
		self.prescription = try Reference(from: _container, forKeyIfPresent: .prescription)
		self.reasonGiven = try [CodeableConcept](from: _container, forKeyIfPresent: .reasonGiven)
		self.reasonNotGiven = try [CodeableConcept](from: _container, forKeyIfPresent: .reasonNotGiven)
		self.status = try FHIRPrimitive<MedicationAdministrationStatus>(from: _container, forKey: .status, auxiliaryKey: ._status)
		self.text = try Narrative(from: _container, forKeyIfPresent: .text)
		self.wasNotGiven = try FHIRPrimitive<FHIRBool>(from: _container, forKeyIfPresent: .wasNotGiven, auxiliaryKey: ._wasNotGiven)
	}
	
	/// Encodable
	public func encode(to encoder: Encoder) throws {
		var _container = encoder.container(keyedBy: CodingKeys.self)
		// Encode resourceType
		try _container.encode(Self.resourceType, forKey: .resourceType)
		// Encode all our properties (own and inherited)
		try contained?.encode(on: &_container, forKey: .contained)
		try device?.encode(on: &_container, forKey: .device)
		try dosage?.encode(on: &_container, forKey: .dosage)
		
			switch effectiveTime {
			case .dateTime(let _value):
				try _value.encode(on: &_container, forKey: .effectiveTimeDateTime, auxiliaryKey: ._effectiveTimeDateTime)
			case .period(let _value):
				try _value.encode(on: &_container, forKey: .effectiveTimePeriod)
			}
		
		try encounter?.encode(on: &_container, forKey: .encounter)
		try `extension`?.encode(on: &_container, forKey: .`extension`)
		try id?.encode(on: &_container, forKey: .id, auxiliaryKey: ._id)
		try identifier?.encode(on: &_container, forKey: .identifier)
		try implicitRules?.encode(on: &_container, forKey: .implicitRules, auxiliaryKey: ._implicitRules)
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
		try practitioner?.encode(on: &_container, forKey: .practitioner)
		try prescription?.encode(on: &_container, forKey: .prescription)
		try reasonGiven?.encode(on: &_container, forKey: .reasonGiven)
		try reasonNotGiven?.encode(on: &_container, forKey: .reasonNotGiven)
		try status.encode(on: &_container, forKey: .status, auxiliaryKey: ._status)
		try text?.encode(on: &_container, forKey: .text)
		try wasNotGiven?.encode(on: &_container, forKey: .wasNotGiven, auxiliaryKey: ._wasNotGiven)
	}
}

/**
 Details of how medication was taken.
 
 Describes the medication dosage information details e.g. dose, rate, site, route, etc.
 */
public typealias MedicationAdministrationDosage = BackboneElement
