//
//  UserDefaultObservedChange.swift
//  UserDefaultsStorable
//
//  Created by mrfour on 2019/11/13.
//  Copyright © 2019 mrfour. All rights reserved.
//

import Foundation

public struct UserDefaultObservedChange<Value> {
    let kind: NSKeyValueChange
    let indices: IndexSet?
    let isPrior: Bool
    let oldValue: Value?
    let newValue: Value?

    init(_ change: [NSKeyValueChangeKey: Any]) {
        kind = NSKeyValueChange(rawValue: change[.kindKey] as! UInt)!
        indices = change[.indexesKey] as? IndexSet
        isPrior = change[.notificationIsPriorKey] as? Bool ?? false
        oldValue = change[.oldKey] as? Value
        newValue = change[.newKey] as? Value
    }
}

