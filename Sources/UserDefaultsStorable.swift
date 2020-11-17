//
//  UserDefaultsStorable.swift
//  UserDefaultsStorable
//
//  Created by mrfour on 2019/11/9.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

/// A type can be stored in `UserDefaults`.
///
/// Types that conform to the `UserDefaultsStorable` protocol can be converted to data supported by `UserDefaults` with
/// the provided `UserDefaultsBridge`.
///
/// ## Conforming to the UserDefaultsStorable protocol
/// Adds `UserDefaultsStorable` conformance to your custom type by providing a `userDefaultsBridge` property.
///
/// Takes the following simple `Point` struct as an example.
/// ```swift
/// struct Point {
///    let x: Int, y: Int
/// }
/// ```
/// After implementing the `userDefaultsBridge` property and declaring `UserDefaultsStorable` conformance, the `Point`
/// type can be converted to data can be stored in `UserDefaults`.
/// ```
/// extension Point: UserDefaultsStorable {
///     static var userDefaultsBridge: UserDefaultsBridge<Point> {
///         UserDefaultsBridge(
///             serialization: { point in
///                 return ["x": point.x, "y": point: point.y]
///             },
///             deserialization: { object in
///                 guard
///                     let dict = object as? [String: Int]
///                     let x = dict["x"] as? Int,
///                     let y = dict["y"] as? Int
///                 else { return nil }
///                 return Point(x: x, y: y)
///             }
///         }
///     }
/// }
///
/// let point = Point(x: 1, y: 2)
///
/// let bridge = Point.userDefaultsBridge
/// let data = bridge.serialize(point)
/// UserDefaults.standard.set(data, forKey: "point")
/// ```
///
public protocol UserDefaultsStorable {
    associatedtype BridgedType
    /// An object that converts value to and from data stored in `UserDefaults`.
    static var userDefaultsBridge: UserDefaultsBridge<BridgedType> { get }
}

public extension UserDefaultsStorable where Self: Codable {
    static var userDefaultsBridge: UserDefaultsBridge<Self> {
        UserDefaultsBridge(
            serialization: {
                $0.encoded()
            },
            deserialization: { object in
                guard let data = object as? Data else { return nil }
                return Self.init(data: data)
            }
        )
    }
}

public extension UserDefaultsStorable where Self: RawRepresentable, RawValue: UserDefaultsStorable {
    static var userDefaultsBridge: UserDefaultsBridge<Self> {
        UserDefaultsBridge(
            serialization: { $0?.rawValue },
            deserialization: { object in
                guard let rawValue = object as? RawValue else { return nil }
                return Self.init(rawValue: rawValue)
            }
        )
    }
}

public extension UserDefaultsStorable where Self: Codable, Self: RawRepresentable, RawValue: UserDefaultsStorable {
    static var userDefaultsBridge: UserDefaultsBridge<Self> {
        UserDefaultsBridge(
            serialization: { $0?.rawValue },
            deserialization: { object in
                guard let rawValue = object as? RawValue else { return nil }
                return Self.init(rawValue: rawValue)
            }
        )
    }
}

extension Array: UserDefaultsStorable where Element: UserDefaultsStorable {
    public static var userDefaultsBridge: UserDefaultsBridge<[Element.BridgedType]> {
        UserDefaultsBridge<[Element.BridgedType]>(
            serialization: { value in
                let bridge = Element.userDefaultsBridge
                return value?.map(bridge.serialize)
            },
            deserialization: { object in
                guard let object = object as? [Any] else { return nil }
                let bridge = Element.userDefaultsBridge
                return object.map(bridge.deserialize) as? [Element.BridgedType]
            }
        )
    }
}
