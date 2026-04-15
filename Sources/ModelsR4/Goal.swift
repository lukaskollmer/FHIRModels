//
//  Goal.swift
//  HealthSoftware
//
//  Generated from FHIR 4.0.1-9346c8cc45 (http://hl7.org/fhir/StructureDefinition/Goal)
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
 Describes the intended objective(s) for a patient, group or organization.
 
 Describes the intended objective(s) for a patient, group or organization care, for example, weight loss, restoring an
 activity of daily living, obtaining herd immunity via immunization, meeting a process improvement objective, etc.
 */
public struct Goal: DomainResource {
	
	public static let resourceType: ResourceType = .goal
	
	/// All possible types for "start[x]"
	public indirect enum StartX: Equatable, Hashable, Sendable {
		case codeableConcept(CodeableConcept)
		case date(FHIRPrimitive<FHIRDate>)
	}
	
	/// in-progress | improving | worsening | no-change | achieved | sustaining | not-achieved | no-progress | not-
	/// attainable
	public var achievementStatus: CodeableConcept?
	
	/// Issues addressed by this goal
	public var addresses: [Reference]?
	
	/// E.g. Treatment, dietary, behavioral, etc.
	public var category: [CodeableConcept]?
	
	/// Contained, inline Resources
	public var contained: [ResourceProxy]?
	
	/// Code or text describing goal
	public var description_fhir: CodeableConcept
	
	/// Who's responsible for creating Goal?
	public var expressedBy: Reference?
	
	/// Additional content defined by implementations
	public var `extension`: [Extension]?
	
	/// Logical id of this artifact
	public var id: FHIRPrimitive<FHIRString>?
	
	/// External Ids for this goal
	public var identifier: [Identifier]?
	
	/// A set of rules under which this content was created
	public var implicitRules: FHIRPrimitive<FHIRURI>?
	
	/// Language of the resource content
	public var language: FHIRPrimitive<FHIRString>?
	
	/// The state of the goal throughout its lifecycle.
	public var lifecycleStatus: FHIRPrimitive<GoalLifecycleStatus>
	
	/// Metadata about the resource
	public var meta: Meta?
	
	/// Extensions that cannot be ignored
	public var modifierExtension: [Extension]?
	
	/// Comments about the goal
	public var note: [Annotation]?
	
	/// What result was achieved regarding the goal?
	public var outcomeCode: [CodeableConcept]?
	
	/// Observation that resulted from goal
	public var outcomeReference: [Reference]?
	
	/// high-priority | medium-priority | low-priority
	public var priority: CodeableConcept?
	
	/// When goal pursuit begins
	/// One of `start[x]`
	public var start: StartX?
	
	/// When goal status took effect
	public var statusDate: FHIRPrimitive<FHIRDate>?
	
	/// Reason for current status
	public var statusReason: FHIRPrimitive<FHIRString>?
	
	/// Who this goal is intended for
	public var subject: Reference
	
	/// Target outcome for the goal
	public var target: [GoalTarget]?
	
	/// Text summary of the resource, for human interpretation
	public var text: Narrative?
	
	/// Designated initializer taking all required properties
	public init(description_fhir: CodeableConcept, lifecycleStatus: FHIRPrimitive<GoalLifecycleStatus>, subject: Reference) {
		self.description_fhir = description_fhir
		self.lifecycleStatus = lifecycleStatus
		self.subject = subject
	}
	
	/// Convenience initializer
	public init(
		achievementStatus: CodeableConcept? = nil,
		addresses: [Reference]? = nil,
		category: [CodeableConcept]? = nil,
		contained: [ResourceProxy]? = nil,
		description_fhir: CodeableConcept,
		expressedBy: Reference? = nil,
		`extension`: [Extension]? = nil,
		id: FHIRPrimitive<FHIRString>? = nil,
		identifier: [Identifier]? = nil,
		implicitRules: FHIRPrimitive<FHIRURI>? = nil,
		language: FHIRPrimitive<FHIRString>? = nil,
		lifecycleStatus: FHIRPrimitive<GoalLifecycleStatus>,
		meta: Meta? = nil,
		modifierExtension: [Extension]? = nil,
		note: [Annotation]? = nil,
		outcomeCode: [CodeableConcept]? = nil,
		outcomeReference: [Reference]? = nil,
		priority: CodeableConcept? = nil,
		start: StartX? = nil,
		statusDate: FHIRPrimitive<FHIRDate>? = nil,
		statusReason: FHIRPrimitive<FHIRString>? = nil,
		subject: Reference,
		target: [GoalTarget]? = nil,
		text: Narrative? = nil
	) {
		self.init(description_fhir: description_fhir, lifecycleStatus: lifecycleStatus, subject: subject)
		self.achievementStatus = achievementStatus
		self.addresses = addresses
		self.category = category
		self.contained = contained
		self.expressedBy = expressedBy
		self.`extension` = `extension`
		self.id = id
		self.identifier = identifier
		self.implicitRules = implicitRules
		self.language = language
		self.meta = meta
		self.modifierExtension = modifierExtension
		self.note = note
		self.outcomeCode = outcomeCode
		self.outcomeReference = outcomeReference
		self.priority = priority
		self.start = start
		self.statusDate = statusDate
		self.statusReason = statusReason
		self.target = target
		self.text = text
	}
	
	// MARK: - Codable
	
	private enum CodingKeys: String, CodingKey {
		case resourceType
		case achievementStatus
		case addresses
		case category
		case contained
		case description_fhir = "description"
		case expressedBy
		case `extension` = "extension"
		case id; case _id
		case identifier
		case implicitRules; case _implicitRules
		case language; case _language
		case lifecycleStatus; case _lifecycleStatus
		case meta
		case modifierExtension
		case note
		case outcomeCode
		case outcomeReference
		case priority
		case startCodeableConcept
		case startDate; case _startDate
		case statusDate; case _statusDate
		case statusReason; case _statusReason
		case subject
		case target
		case text
	}

	/// Initializer for Decodable
	public init(from decoder: Decoder) throws {
		let _container = try decoder.container(keyedBy: CodingKeys.self)
		
		// Decode all our properties (own and inherited)
		self.achievementStatus = try CodeableConcept(from: _container, forKeyIfPresent: .achievementStatus)
		self.addresses = try [Reference](from: _container, forKeyIfPresent: .addresses)
		self.category = try [CodeableConcept](from: _container, forKeyIfPresent: .category)
		self.contained = try [ResourceProxy](from: _container, forKeyIfPresent: .contained)
		self.description_fhir = try CodeableConcept(from: _container, forKey: .description_fhir)
		self.expressedBy = try Reference(from: _container, forKeyIfPresent: .expressedBy)
		self.`extension` = try [Extension](from: _container, forKeyIfPresent: .`extension`)
		self.id = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .id, auxiliaryKey: ._id)
		self.identifier = try [Identifier](from: _container, forKeyIfPresent: .identifier)
		self.implicitRules = try FHIRPrimitive<FHIRURI>(from: _container, forKeyIfPresent: .implicitRules, auxiliaryKey: ._implicitRules)
		self.language = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .language, auxiliaryKey: ._language)
		self.lifecycleStatus = try FHIRPrimitive<GoalLifecycleStatus>(from: _container, forKey: .lifecycleStatus, auxiliaryKey: ._lifecycleStatus)
		self.meta = try Meta(from: _container, forKeyIfPresent: .meta)
		self.modifierExtension = try [Extension](from: _container, forKeyIfPresent: .modifierExtension)
		self.note = try [Annotation](from: _container, forKeyIfPresent: .note)
		self.outcomeCode = try [CodeableConcept](from: _container, forKeyIfPresent: .outcomeCode)
		self.outcomeReference = try [Reference](from: _container, forKeyIfPresent: .outcomeReference)
		self.priority = try CodeableConcept(from: _container, forKeyIfPresent: .priority)
		var _t_start: StartX? = nil
		if let startDate = try FHIRPrimitive<FHIRDate>(from: _container, forKeyIfPresent: .startDate, auxiliaryKey: ._startDate) {
			if _t_start != nil {
				throw DecodingError.dataCorruptedError(forKey: .startDate, in: _container, debugDescription: "More than one value provided for \"start\"")
			}
			_t_start = .date(startDate)
		}
		if let startCodeableConcept = try CodeableConcept(from: _container, forKeyIfPresent: .startCodeableConcept) {
			if _t_start != nil {
				throw DecodingError.dataCorruptedError(forKey: .startCodeableConcept, in: _container, debugDescription: "More than one value provided for \"start\"")
			}
			_t_start = .codeableConcept(startCodeableConcept)
		}
		self.start = _t_start
		self.statusDate = try FHIRPrimitive<FHIRDate>(from: _container, forKeyIfPresent: .statusDate, auxiliaryKey: ._statusDate)
		self.statusReason = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .statusReason, auxiliaryKey: ._statusReason)
		self.subject = try Reference(from: _container, forKey: .subject)
		self.target = try [GoalTarget](from: _container, forKeyIfPresent: .target)
		self.text = try Narrative(from: _container, forKeyIfPresent: .text)
	}
	
	/// Encodable
	public func encode(to encoder: Encoder) throws {
		var _container = encoder.container(keyedBy: CodingKeys.self)
		// Encode resourceType
		try _container.encode(Self.resourceType, forKey: .resourceType)
		// Encode all our properties (own and inherited)
		try achievementStatus?.encode(on: &_container, forKey: .achievementStatus)
		try addresses?.encode(on: &_container, forKey: .addresses)
		try category?.encode(on: &_container, forKey: .category)
		try contained?.encode(on: &_container, forKey: .contained)
		try description_fhir.encode(on: &_container, forKey: .description_fhir)
		try expressedBy?.encode(on: &_container, forKey: .expressedBy)
		try `extension`?.encode(on: &_container, forKey: .`extension`)
		try id?.encode(on: &_container, forKey: .id, auxiliaryKey: ._id)
		try identifier?.encode(on: &_container, forKey: .identifier)
		try implicitRules?.encode(on: &_container, forKey: .implicitRules, auxiliaryKey: ._implicitRules)
		try language?.encode(on: &_container, forKey: .language, auxiliaryKey: ._language)
		try lifecycleStatus.encode(on: &_container, forKey: .lifecycleStatus, auxiliaryKey: ._lifecycleStatus)
		try meta?.encode(on: &_container, forKey: .meta)
		try modifierExtension?.encode(on: &_container, forKey: .modifierExtension)
		try note?.encode(on: &_container, forKey: .note)
		try outcomeCode?.encode(on: &_container, forKey: .outcomeCode)
		try outcomeReference?.encode(on: &_container, forKey: .outcomeReference)
		try priority?.encode(on: &_container, forKey: .priority)
		if let _enum = start {
			switch _enum {
			case .date(let _value):
				try _value.encode(on: &_container, forKey: .startDate, auxiliaryKey: ._startDate)
			case .codeableConcept(let _value):
				try _value.encode(on: &_container, forKey: .startCodeableConcept)
			}
		}
		try statusDate?.encode(on: &_container, forKey: .statusDate, auxiliaryKey: ._statusDate)
		try statusReason?.encode(on: &_container, forKey: .statusReason, auxiliaryKey: ._statusReason)
		try subject.encode(on: &_container, forKey: .subject)
		try target?.encode(on: &_container, forKey: .target)
		try text?.encode(on: &_container, forKey: .text)
	}
}

/**
 Target outcome for the goal.
 
 Indicates what should be done by when.
 */
public struct GoalTarget: BackboneElement {
	
	/// All possible types for "detail[x]"
	public indirect enum DetailX: Equatable, Hashable, Sendable {
		case boolean(FHIRPrimitive<FHIRBool>)
		case codeableConcept(CodeableConcept)
		case integer(FHIRPrimitive<FHIRInteger>)
		case quantity(Quantity)
		case range(Range)
		case ratio(Ratio)
		case string(FHIRPrimitive<FHIRString>)
	}
	
	/// All possible types for "due[x]"
	public indirect enum DueX: Equatable, Hashable, Sendable {
		case date(FHIRPrimitive<FHIRDate>)
		case duration(Duration)
	}
	
	/// The target value to be achieved
	/// One of `detail[x]`
	public var detail: DetailX?
	
	/// Reach goal on or before
	/// One of `due[x]`
	public var due: DueX?
	
	/// Additional content defined by implementations
	public var `extension`: [Extension]?
	
	/// Unique id for inter-element referencing
	public var id: FHIRPrimitive<FHIRString>?
	
	/// The parameter whose value is being tracked
	public var measure: CodeableConcept?
	
	/// Extensions that cannot be ignored even if unrecognized
	public var modifierExtension: [Extension]?
	
	/// Designated initializer taking all required properties
	public init() {
	}
	
	/// Convenience initializer
	public init(
		detail: DetailX? = nil,
		due: DueX? = nil,
		`extension`: [Extension]? = nil,
		id: FHIRPrimitive<FHIRString>? = nil,
		measure: CodeableConcept? = nil,
		modifierExtension: [Extension]? = nil
	) {
		self.init()
		self.detail = detail
		self.due = due
		self.`extension` = `extension`
		self.id = id
		self.measure = measure
		self.modifierExtension = modifierExtension
	}
	
	// MARK: - Codable
	
	private enum CodingKeys: String, CodingKey {
		case detailBoolean; case _detailBoolean
		case detailCodeableConcept
		case detailInteger; case _detailInteger
		case detailQuantity
		case detailRange
		case detailRatio
		case detailString; case _detailString
		case dueDate; case _dueDate
		case dueDuration
		case `extension` = "extension"
		case id; case _id
		case measure
		case modifierExtension
	}

	/// Initializer for Decodable
	public init(from decoder: Decoder) throws {
		let _container = try decoder.container(keyedBy: CodingKeys.self)
		
		// Decode all our properties (own and inherited)
		var _t_detail: DetailX? = nil
		if let detailQuantity = try Quantity(from: _container, forKeyIfPresent: .detailQuantity) {
			if _t_detail != nil {
				throw DecodingError.dataCorruptedError(forKey: .detailQuantity, in: _container, debugDescription: "More than one value provided for \"detail\"")
			}
			_t_detail = .quantity(detailQuantity)
		}
		if let detailRange = try Range(from: _container, forKeyIfPresent: .detailRange) {
			if _t_detail != nil {
				throw DecodingError.dataCorruptedError(forKey: .detailRange, in: _container, debugDescription: "More than one value provided for \"detail\"")
			}
			_t_detail = .range(detailRange)
		}
		if let detailCodeableConcept = try CodeableConcept(from: _container, forKeyIfPresent: .detailCodeableConcept) {
			if _t_detail != nil {
				throw DecodingError.dataCorruptedError(forKey: .detailCodeableConcept, in: _container, debugDescription: "More than one value provided for \"detail\"")
			}
			_t_detail = .codeableConcept(detailCodeableConcept)
		}
		if let detailString = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .detailString, auxiliaryKey: ._detailString) {
			if _t_detail != nil {
				throw DecodingError.dataCorruptedError(forKey: .detailString, in: _container, debugDescription: "More than one value provided for \"detail\"")
			}
			_t_detail = .string(detailString)
		}
		if let detailBoolean = try FHIRPrimitive<FHIRBool>(from: _container, forKeyIfPresent: .detailBoolean, auxiliaryKey: ._detailBoolean) {
			if _t_detail != nil {
				throw DecodingError.dataCorruptedError(forKey: .detailBoolean, in: _container, debugDescription: "More than one value provided for \"detail\"")
			}
			_t_detail = .boolean(detailBoolean)
		}
		if let detailInteger = try FHIRPrimitive<FHIRInteger>(from: _container, forKeyIfPresent: .detailInteger, auxiliaryKey: ._detailInteger) {
			if _t_detail != nil {
				throw DecodingError.dataCorruptedError(forKey: .detailInteger, in: _container, debugDescription: "More than one value provided for \"detail\"")
			}
			_t_detail = .integer(detailInteger)
		}
		if let detailRatio = try Ratio(from: _container, forKeyIfPresent: .detailRatio) {
			if _t_detail != nil {
				throw DecodingError.dataCorruptedError(forKey: .detailRatio, in: _container, debugDescription: "More than one value provided for \"detail\"")
			}
			_t_detail = .ratio(detailRatio)
		}
		self.detail = _t_detail
		var _t_due: DueX? = nil
		if let dueDate = try FHIRPrimitive<FHIRDate>(from: _container, forKeyIfPresent: .dueDate, auxiliaryKey: ._dueDate) {
			if _t_due != nil {
				throw DecodingError.dataCorruptedError(forKey: .dueDate, in: _container, debugDescription: "More than one value provided for \"due\"")
			}
			_t_due = .date(dueDate)
		}
		if let dueDuration = try Duration(from: _container, forKeyIfPresent: .dueDuration) {
			if _t_due != nil {
				throw DecodingError.dataCorruptedError(forKey: .dueDuration, in: _container, debugDescription: "More than one value provided for \"due\"")
			}
			_t_due = .duration(dueDuration)
		}
		self.due = _t_due
		self.`extension` = try [Extension](from: _container, forKeyIfPresent: .`extension`)
		self.id = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .id, auxiliaryKey: ._id)
		self.measure = try CodeableConcept(from: _container, forKeyIfPresent: .measure)
		self.modifierExtension = try [Extension](from: _container, forKeyIfPresent: .modifierExtension)
	}
	
	/// Encodable
	public func encode(to encoder: Encoder) throws {
		var _container = encoder.container(keyedBy: CodingKeys.self)
		// Encode all our properties (own and inherited)
		if let _enum = detail {
			switch _enum {
			case .quantity(let _value):
				try _value.encode(on: &_container, forKey: .detailQuantity)
			case .range(let _value):
				try _value.encode(on: &_container, forKey: .detailRange)
			case .codeableConcept(let _value):
				try _value.encode(on: &_container, forKey: .detailCodeableConcept)
			case .string(let _value):
				try _value.encode(on: &_container, forKey: .detailString, auxiliaryKey: ._detailString)
			case .boolean(let _value):
				try _value.encode(on: &_container, forKey: .detailBoolean, auxiliaryKey: ._detailBoolean)
			case .integer(let _value):
				try _value.encode(on: &_container, forKey: .detailInteger, auxiliaryKey: ._detailInteger)
			case .ratio(let _value):
				try _value.encode(on: &_container, forKey: .detailRatio)
			}
		}
		if let _enum = due {
			switch _enum {
			case .date(let _value):
				try _value.encode(on: &_container, forKey: .dueDate, auxiliaryKey: ._dueDate)
			case .duration(let _value):
				try _value.encode(on: &_container, forKey: .dueDuration)
			}
		}
		try `extension`?.encode(on: &_container, forKey: .`extension`)
		try id?.encode(on: &_container, forKey: .id, auxiliaryKey: ._id)
		try measure?.encode(on: &_container, forKey: .measure)
		try modifierExtension?.encode(on: &_container, forKey: .modifierExtension)
	}
}
