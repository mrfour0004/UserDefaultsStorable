//
//  UserDefaultsBridge.swift
//  UserDefaultsStorable
//
//  Created by mrfour on 2019/11/19.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

/// An object that converts between data can be stored in `UserDefaults` and the equivalent `Value` object.
public struct UserDefaultsBridge<Value> {
    /// A block serializes the given value to an object that can be stored in `UserDefaults`.
    let serialize: (Value?) -> Any?
    /// A block deserializes value from the data stored in `UserDefaults`.
    let deserialize: (Any?) -> Value?

    /// Returns a `UserDefaultsBridge` object with the given serialzation and deserialization.
    /// - Parameters:
    ///   - serialization: A block serializes a given value to data can be stored in `UserDefaults`.
    ///   - deserialization: A block deserializes data stored in `UserDefaults` to an equivalent `Value` object.
    public init(
        serialization: @escaping (Value?) -> Any? = { $0 },
        deserialization: @escaping (Any?) -> Value? = { $0 as? Value }
    ) {
        self.serialize = serialization
        self.deserialize = deserialization
    }
}
