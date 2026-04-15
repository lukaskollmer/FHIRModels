//
//  MedicationOrder.swift
//  HealthSoftware
//
//  Generated from FHIR 1.0.2.7202 (http://hl7.org/fhir/StructureDefinition/MedicationOrder)
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
 Prescription of medication to for patient.
 
 An order for both supply of the medication and the instructions for administration of the medication to a patient. The
 resource is called "MedicationOrder" rather than "MedicationPrescription" to generalize the use across inpatient and
 outpatient settings as well as for care plans, etc.
 */
public struct MedicationOrder: DomainResource {
	
	public static let resourceType: ResourceType = .medicationOrder
	
	/// All possible types for "medication[x]"
	public indirect enum MedicationX: Equatable, Hashable, Sendable {
		case codeableConcept(CodeableConcept)
		case reference(Reference)
	}
	
	/// All possible types for "reason[x]"
	public indirect enum ReasonX: Equatable, Hashable, Sendable {
		case codeableConcept(CodeableConcept)
		case reference(Reference)
	}
	
	/// Contained, inline Resources
	public var contained: [ResourceProxy]?
	
	/// When prescription was stopped
	public var dateEnded: FHIRPrimitive<DateTime>?
	
	/// When prescription was authorized
	public var dateWritten: FHIRPrimitive<DateTime>?
	
	/// Medication supply authorization
	public var dispenseRequest: MedicationOrderDispenseRequest?
	
	/// How medication should be taken
	public var dosageInstruction: [MedicationOrderDosageInstruction]?
	
	/// Created during encounter/admission/stay
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
	
	/// Medication to be taken
	/// One of `medication[x]`
	public var medication: MedicationX
	
	/// Metadata about the resource
	public var meta: Meta?
	
	/// Extensions that cannot be ignored
	public var modifierExtension: [Extension]?
	
	/// Information about the prescription
	public var note: FHIRPrimitive<FHIRString>?
	
	/// Who prescription is for
	public var patient: Reference?
	
	/// Who ordered the medication(s)
	public var prescriber: Reference?
	
	/// An order/prescription that this supersedes
	public var priorPrescription: Reference?
	
	/// Reason or indication for writing the prescription
	/// One of `reason[x]`
	public var reason: ReasonX?
	
	/// Why prescription was stopped
	public var reasonEnded: CodeableConcept?
	
	/// A code specifying the state of the order.  Generally this will be active or completed state.
	/// Restricted to: ['active', 'on-hold', 'completed', 'entered-in-error', 'stopped', 'draft']
	public var status: FHIRPrimitive<MedicationOrderStatus>?
	
	/// Any restrictions on medication substitution
	public var substitution: MedicationOrderSubstitution?
	
	/// Text summary of the resource, for human interpretation
	public var text: Narrative?
	
	/// Designated initializer taking all required properties
	public init(medication: MedicationX) {
		self.medication = medication
	}
	
	/// Convenience initializer
	public init(
		contained: [ResourceProxy]? = nil,
		dateEnded: FHIRPrimitive<DateTime>? = nil,
		dateWritten: FHIRPrimitive<DateTime>? = nil,
		dispenseRequest: MedicationOrderDispenseRequest? = nil,
		dosageInstruction: [MedicationOrderDosageInstruction]? = nil,
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
		patient: Reference? = nil,
		prescriber: Reference? = nil,
		priorPrescription: Reference? = nil,
		reason: ReasonX? = nil,
		reasonEnded: CodeableConcept? = nil,
		status: FHIRPrimitive<MedicationOrderStatus>? = nil,
		substitution: MedicationOrderSubstitution? = nil,
		text: Narrative? = nil
	) {
		self.init(medication: medication)
		self.contained = contained
		self.dateEnded = dateEnded
		self.dateWritten = dateWritten
		self.dispenseRequest = dispenseRequest
		self.dosageInstruction = dosageInstruction
		self.encounter = encounter
		self.`extension` = `extension`
		self.id = id
		self.identifier = identifier
		self.implicitRules = implicitRules
		self.language = language
		self.meta = meta
		self.modifierExtension = modifierExtension
		self.note = note
		self.patient = patient
		self.prescriber = prescriber
		self.priorPrescription = priorPrescription
		self.reason = reason
		self.reasonEnded = reasonEnded
		self.status = status
		self.substitution = substitution
		self.text = text
	}
	
	// MARK: - Codable
	
	private enum CodingKeys: String, CodingKey {
		case resourceType
		case contained
		case dateEnded; case _dateEnded
		case dateWritten; case _dateWritten
		case dispenseRequest
		case dosageInstruction
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
		case prescriber
		case priorPrescription
		case reasonCodeableConcept
		case reasonEnded
		case reasonReference
		case status; case _status
		case substitution
		case text
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
		self.dateEnded = try FHIRPrimitive<DateTime>(from: _container, forKeyIfPresent: .dateEnded, auxiliaryKey: ._dateEnded)
		self.dateWritten = try FHIRPrimitive<DateTime>(from: _container, forKeyIfPresent: .dateWritten, auxiliaryKey: ._dateWritten)
		self.dispenseRequest = try MedicationOrderDispenseRequest(from: _container, forKeyIfPresent: .dispenseRequest)
		self.dosageInstruction = try [MedicationOrderDosageInstruction](from: _container, forKeyIfPresent: .dosageInstruction)
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
		self.patient = try Reference(from: _container, forKeyIfPresent: .patient)
		self.prescriber = try Reference(from: _container, forKeyIfPresent: .prescriber)
		self.priorPrescription = try Reference(from: _container, forKeyIfPresent: .priorPrescription)
		var _t_reason: ReasonX? = nil
		if let reasonCodeableConcept = try CodeableConcept(from: _container, forKeyIfPresent: .reasonCodeableConcept) {
			if _t_reason != nil {
				throw DecodingError.dataCorruptedError(forKey: .reasonCodeableConcept, in: _container, debugDescription: "More than one value provided for \"reason\"")
			}
			_t_reason = .codeableConcept(reasonCodeableConcept)
		}
		if let reasonReference = try Reference(from: _container, forKeyIfPresent: .reasonReference) {
			if _t_reason != nil {
				throw DecodingError.dataCorruptedError(forKey: .reasonReference, in: _container, debugDescription: "More than one value provided for \"reason\"")
			}
			_t_reason = .reference(reasonReference)
		}
		self.reason = _t_reason
		self.reasonEnded = try CodeableConcept(from: _container, forKeyIfPresent: .reasonEnded)
		self.status = try FHIRPrimitive<MedicationOrderStatus>(from: _container, forKeyIfPresent: .status, auxiliaryKey: ._status)
		self.substitution = try MedicationOrderSubstitution(from: _container, forKeyIfPresent: .substitution)
		self.text = try Narrative(from: _container, forKeyIfPresent: .text)
	}
	
	/// Encodable
	public func encode(to encoder: Encoder) throws {
		var _container = encoder.container(keyedBy: CodingKeys.self)
		// Encode resourceType
		try _container.encode(Self.resourceType, forKey: .resourceType)
		// Encode all our properties (own and inherited)
		try contained?.encode(on: &_container, forKey: .contained)
		try dateEnded?.encode(on: &_container, forKey: .dateEnded, auxiliaryKey: ._dateEnded)
		try dateWritten?.encode(on: &_container, forKey: .dateWritten, auxiliaryKey: ._dateWritten)
		try dispenseRequest?.encode(on: &_container, forKey: .dispenseRequest)
		try dosageInstruction?.encode(on: &_container, forKey: .dosageInstruction)
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
		try patient?.encode(on: &_container, forKey: .patient)
		try prescriber?.encode(on: &_container, forKey: .prescriber)
		try priorPrescription?.encode(on: &_container, forKey: .priorPrescription)
		if let _enum = reason {
			switch _enum {
			case .codeableConcept(let _value):
				try _value.encode(on: &_container, forKey: .reasonCodeableConcept)
			case .reference(let _value):
				try _value.encode(on: &_container, forKey: .reasonReference)
			}
		}
		try reasonEnded?.encode(on: &_container, forKey: .reasonEnded)
		try status?.encode(on: &_container, forKey: .status, auxiliaryKey: ._status)
		try substitution?.encode(on: &_container, forKey: .substitution)
		try text?.encode(on: &_container, forKey: .text)
	}
}

/**
 Medication supply authorization.
 
 Indicates the specific details for the dispense or medication supply part of a medication order (also known as a
 Medication Prescription).  Note that this information is NOT always sent with the order.  There may be in some settings
 (e.g. hospitals) institutional or system support for completing the dispense details in the pharmacy department.
 */
public typealias MedicationOrderDispenseRequest = BackboneElement

/**
 How medication should be taken.
 
 Indicates how the medication is to be used by the patient.
 */
public typealias MedicationOrderDosageInstruction = BackboneElement

/**
 Any restrictions on medication substitution.
 
 Indicates whether or not substitution can or should be part of the dispense. In some cases substitution must happen, in
 other cases substitution must not happen, and in others it does not matter. This block explains the prescriber's
 intent. If nothing is specified substitution may be done.
 */
public typealias MedicationOrderSubstitution = BackboneElement
