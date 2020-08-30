//
//  UserDefaultObservation.swift
//  UserDefaultsStorable
//
//  Created by mrfour on 2019/11/12.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

public final class UserDefaultObservation: NSObject {

    private let userDefaults: UserDefaults
    private let key: String
    private let changeHandler: (_ change: [NSKeyValueChangeKey: Any]) -> Void

    private var isObserverRemoved = false

    init<Value>(
        userDefaults: UserDefaults,
        key: String,
        options: NSKeyValueObservingOptions,
        changeHandler: @escaping (UserDefaultObservedChange<Value>) -> Void
    ) {
        self.userDefaults = userDefaults
        self.key = key
        self.changeHandler = { changeInfo in
            let change = UserDefaultObservedChange<Value>(changeInfo)
            changeHandler(change)
        }
        super.init()
        userDefaults.addObserver(self, forKeyPath: key, options: options, context: nil)
    }

    deinit {
        invalidate()
    }

    func invalidate() {
        guard !isObserverRemoved else { return }
        isObserverRemoved = true
        userDefaults.removeObserver(self, forKeyPath: key)
    }

    override public func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard userDefaults == object as? NSObject, let change = change else {
            return invalidate()
        }
        changeHandler(change)
    }

}

