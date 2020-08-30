//
//  UserDefaultsStorable+BuiltIn.swift
//  UserDefaultsStorable
//
//  Created by mrfour on 2019/11/25.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

protocol BuiltInUserDefaultsStorable: UserDefaultsStorable {}

extension BuiltInUserDefaultsStorable {
    public static var userDefaultsBridge: UserDefaultsBridge<Self> {
        UserDefaultsBridge()
    }
}

extension Bool: BuiltInUserDefaultsStorable {}
extension Int: BuiltInUserDefaultsStorable {}
extension Float: BuiltInUserDefaultsStorable {}
extension Double: BuiltInUserDefaultsStorable {}
extension Data: BuiltInUserDefaultsStorable {}
extension Date: BuiltInUserDefaultsStorable {}
extension String: BuiltInUserDefaultsStorable {}
extension URL: BuiltInUserDefaultsStorable {}
extension Dictionary: UserDefaultsStorable where Key == String {}
extension Dictionary: BuiltInUserDefaultsStorable where Key == String {}
extension Array: BuiltInUserDefaultsStorable where Element: BuiltInUserDefaultsStorable {}
