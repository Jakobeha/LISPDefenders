//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

extension Dictionary {
    static func +(_ x: [Key : Value], _ y: [Key : Value]) -> [Key : Value] {
        var res = x
        for (key, value) in y {
            res[key] = value
        }
        return res
    }
}
