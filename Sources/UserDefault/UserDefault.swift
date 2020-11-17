//
//  UserDefault.swift
//  UserDefaultsStorable
//
//  Created by mrfour on 2019/11/7.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

/// A manager that reads/saves data from/to the given `UserDefaults` for the given key.
///
/// Use `UserDefault` to wrap a value with a given default value for the specified `key`. Because `defaultValue` is
/// required, declaring a optional property annotated by `@UserDefault` is discouraged.
@propertyWrapper
public struct UserDefault<Value: UserDefaultsStorable>: UserDefaultProtocol {
    public typealias Value = Value

    public let key: String
    public let storage: UserDefaults
    private let defaultValue: Value

    public init(wrappedValue: Value, key: String, storage: UserDefaults = .standard) {
        self.defaultValue = wrappedValue
        self.key = key
        self.storage = storage
    }

    public var wrappedValue: Value {
        get {
            let storedValue = storage.object(forKey: key)
            let bridge = Value.userDefaultsBridge
            return bridge.deserialize(storedValue) ?? defaultValue
        }
        nonmutating set {
            let bridge = Value.userDefaultsBridge
            let value = bridge.serialize(newValue)
            storage.set(value, forKey: key)
        }
    }

    public var projectedValue: UserDefault<Value> {
        self
    }
}
