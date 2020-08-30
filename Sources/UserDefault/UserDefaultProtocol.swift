//
//  UserDefaultProtocol.swift
//  UserDefaultProtocol
//
//  Created by mrfour on 2019/11/11.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

public protocol UserDefaultProtocol {
    associatedtype Value
    associatedtype WrappedValue

    var key: String { get }
    var storage: UserDefaults { get }
    var wrappedValue: WrappedValue { get nonmutating set }
}

public extension UserDefaultProtocol {
    func observe(
        withOptions options: NSKeyValueObservingOptions,
        using changeHandler: @escaping (UserDefaultObservedChange<Value>) -> Void
    ) -> UserDefaultObservation {
        UserDefaultObservation(userDefaults: storage, key: key, options: options, changeHandler: changeHandler)
    }

    func observe(_ changeHandler: @escaping (WrappedValue) -> Void) -> UserDefaultObservation {
        UserDefaultObservation(userDefaults: storage, key: key, options: .new) { (change: UserDefaultObservedChange<Value>) in
            guard let newValue = change.newValue as? WrappedValue else { return }
            changeHandler(newValue as WrappedValue)
        }
    }
}
