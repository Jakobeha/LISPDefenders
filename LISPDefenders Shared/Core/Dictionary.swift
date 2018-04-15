//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

extension Dictionary {
    static func +(_ x: [Key : Value], _ y: [Key : Value]) throws -> [Key : Value] {
        var res = x
        for (key, value) in y {
            guard res[key] == nil else {
                throw DictionaryError.duplicateKey(key, left: res[key]!, right: value)
            }

            res[key] = value
        }
        return res
    }
}

enum DictionaryError<Key, Value>: Error {
    case duplicateKey(Key, left: Value, right: Value)
}
