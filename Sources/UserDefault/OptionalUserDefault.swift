//
//  OptionalUserDefault.swift
//  UserDefaultsStorable
//
//  Created by mrfour on 2019/11/11.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

/// A manager that reads/saves data from/to the given `UserDefaults` for the given key.
///
/// Use `OptionalUserDefault` to wrap a value without a default value. You must declare a property annoated by
/// `@OptionalUserDefault` as optional becuase there is no default value provided.
@propertyWrapper
public struct OptionalUserDefault<Value: UserDefaultsStorable>: UserDefaultProtocol {
    public typealias Value = Value
    
    public let key: String
    public let storage: UserDefaults

    public init(key: String, storage: UserDefaults = .standard) {
        self.key = key
        self.storage = storage
    }

    public var wrappedValue: Value? {
        get {
            let storedValue = storage.object(forKey: key)
            let bridge = Value.userDefaultsBridge
            return bridge.deserialize(storedValue)
        }
        nonmutating set {
            let bridge = Value.userDefaultsBridge
            let value = bridge.serialize(newValue)
            storage.set(value, forKey: key)
        }
    }

    public var projectedValue: OptionalUserDefault<Value> {
        self
    }
}
