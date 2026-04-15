//
//  DosageSafety.swift
//  HealthSoftware
//
//  Generated from FHIR 6.0.0-ballot4 (http://hl7.org/fhir/StructureDefinition/DosageSafety)
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
 Safety Details about the usage of the medication.
 */
public struct DosageSafety: BackboneType {
	
	/// A dose limit for safe use of the medication
	public var doseLimit: [DosageSafetyDoseLimit]?
	
	/// Additional content defined by implementations
	public var `extension`: [Extension]?
	
	/// Unique id for inter-element referencing
	public var id: FHIRPrimitive<FHIRString>?
	
	/// What to do if the instructions lead to exceeding the dose limits
	public var ifExceeded: FHIRPrimitive<FHIRString>?
	
	/// Extensions that cannot be ignored even if unrecognized
	public var modifierExtension: [Extension]?
	
	/// Designated initializer taking all required properties
	public init() {
	}
	
	/// Convenience initializer
	public init(
		doseLimit: [DosageSafetyDoseLimit]? = nil,
		`extension`: [Extension]? = nil,
		id: FHIRPrimitive<FHIRString>? = nil,
		ifExceeded: FHIRPrimitive<FHIRString>? = nil,
		modifierExtension: [Extension]? = nil
	) {
		self.init()
		self.doseLimit = doseLimit
		self.`extension` = `extension`
		self.id = id
		self.ifExceeded = ifExceeded
		self.modifierExtension = modifierExtension
	}
	
	// MARK: - Codable
	
	private enum CodingKeys: String, CodingKey {
		case doseLimit
		case `extension` = "extension"
		case id; case _id
		case ifExceeded; case _ifExceeded
		case modifierExtension
	}

	/// Initializer for Decodable
	public init(from decoder: Decoder) throws {
		let _container = try decoder.container(keyedBy: CodingKeys.self)
		
		// Decode all our properties (own and inherited)
		self.doseLimit = try [DosageSafetyDoseLimit](from: _container, forKeyIfPresent: .doseLimit)
		self.`extension` = try [Extension](from: _container, forKeyIfPresent: .`extension`)
		self.id = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .id, auxiliaryKey: ._id)
		self.ifExceeded = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .ifExceeded, auxiliaryKey: ._ifExceeded)
		self.modifierExtension = try [Extension](from: _container, forKeyIfPresent: .modifierExtension)
	}
	
	/// Encodable
	public func encode(to encoder: Encoder) throws {
		var _container = encoder.container(keyedBy: CodingKeys.self)
		// Encode all our properties (own and inherited)
		try doseLimit?.encode(on: &_container, forKey: .doseLimit)
		try `extension`?.encode(on: &_container, forKey: .`extension`)
		try id?.encode(on: &_container, forKey: .id, auxiliaryKey: ._id)
		try ifExceeded?.encode(on: &_container, forKey: .ifExceeded, auxiliaryKey: ._ifExceeded)
		try modifierExtension?.encode(on: &_container, forKey: .modifierExtension)
	}
}

/**
 A dose limit for safe use of the medication.
 */
public struct DosageSafetyDoseLimit: Element {
	
	/// All possible types for "value[x]"
	public indirect enum ValueX: Equatable, Hashable, Sendable {
		case expression(Expression)
		case integer(FHIRPrimitive<FHIRInteger>)
		case quantity(Quantity)
	}
	
	/// Additional content defined by implementations
	public var `extension`: [Extension]?
	
	/// Unique id for inter-element referencing
	public var id: FHIRPrimitive<FHIRString>?
	
	/// The period over which the quantity is safe to use (if scope = period)
	public var period: Duration?
	
	/// None
	public var scope: FHIRPrimitive<DoseLimitScopeCodes>
	
	/// Additional notes about the dose limit
	public var text: FHIRPrimitive<FHIRString>?
	
	/// Quantity that is safe to use
	/// One of `value[x]`
	public var value: ValueX
	
	/// Designated initializer taking all required properties
	public init(scope: FHIRPrimitive<DoseLimitScopeCodes>, value: ValueX) {
		self.scope = scope
		self.value = value
	}
	
	/// Convenience initializer
	public init(
		`extension`: [Extension]? = nil,
		id: FHIRPrimitive<FHIRString>? = nil,
		period: Duration? = nil,
		scope: FHIRPrimitive<DoseLimitScopeCodes>,
		text: FHIRPrimitive<FHIRString>? = nil,
		value: ValueX
	) {
		self.init(scope: scope, value: value)
		self.`extension` = `extension`
		self.id = id
		self.period = period
		self.text = text
	}
	
	// MARK: - Codable
	
	private enum CodingKeys: String, CodingKey {
		case `extension` = "extension"
		case id; case _id
		case period
		case scope; case _scope
		case text; case _text
		case valueExpression
		case valueInteger; case _valueInteger
		case valueQuantity
	}

	/// Initializer for Decodable
	public init(from decoder: Decoder) throws {
		let _container = try decoder.container(keyedBy: CodingKeys.self)
		
		// Validate that we have at least one of the mandatory properties for expanded properties
		guard _container.contains(CodingKeys.valueExpression) || _container.contains(CodingKeys.valueInteger) || _container.contains(CodingKeys.valueQuantity) else {
			throw DecodingError.valueNotFound(Any.self, DecodingError.Context(codingPath: [CodingKeys.valueExpression, CodingKeys.valueInteger, CodingKeys.valueQuantity], debugDescription: "Must have at least one value for \"value\" but have none"))
		}
		
		// Decode all our properties (own and inherited)
		self.`extension` = try [Extension](from: _container, forKeyIfPresent: .`extension`)
		self.id = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .id, auxiliaryKey: ._id)
		self.period = try Duration(from: _container, forKeyIfPresent: .period)
		self.scope = try FHIRPrimitive<DoseLimitScopeCodes>(from: _container, forKey: .scope, auxiliaryKey: ._scope)
		self.text = try FHIRPrimitive<FHIRString>(from: _container, forKeyIfPresent: .text, auxiliaryKey: ._text)
		var _t_value: ValueX? = nil
		if let valueInteger = try FHIRPrimitive<FHIRInteger>(from: _container, forKeyIfPresent: .valueInteger, auxiliaryKey: ._valueInteger) {
			if _t_value != nil {
				throw DecodingError.dataCorruptedError(forKey: .valueInteger, in: _container, debugDescription: "More than one value provided for \"value\"")
			}
			_t_value = .integer(valueInteger)
		}
		if let valueQuantity = try Quantity(from: _container, forKeyIfPresent: .valueQuantity) {
			if _t_value != nil {
				throw DecodingError.dataCorruptedError(forKey: .valueQuantity, in: _container, debugDescription: "More than one value provided for \"value\"")
			}
			_t_value = .quantity(valueQuantity)
		}
		if let valueExpression = try Expression(from: _container, forKeyIfPresent: .valueExpression) {
			if _t_value != nil {
				throw DecodingError.dataCorruptedError(forKey: .valueExpression, in: _container, debugDescription: "More than one value provided for \"value\"")
			}
			_t_value = .expression(valueExpression)
		}
		self.value = _t_value!
	}
	
	/// Encodable
	public func encode(to encoder: Encoder) throws {
		var _container = encoder.container(keyedBy: CodingKeys.self)
		// Encode all our properties (own and inherited)
		try `extension`?.encode(on: &_container, forKey: .`extension`)
		try id?.encode(on: &_container, forKey: .id, auxiliaryKey: ._id)
		try period?.encode(on: &_container, forKey: .period)
		try scope.encode(on: &_container, forKey: .scope, auxiliaryKey: ._scope)
		try text?.encode(on: &_container, forKey: .text, auxiliaryKey: ._text)
		
			switch value {
			case .integer(let _value):
				try _value.encode(on: &_container, forKey: .valueInteger, auxiliaryKey: ._valueInteger)
			case .quantity(let _value):
				try _value.encode(on: &_container, forKey: .valueQuantity)
			case .expression(let _value):
				try _value.encode(on: &_container, forKey: .valueExpression)
			}
		
	}
}
