//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

extension SExpr {
    init(_ bool: Bool) {
        self = .atom(SAtom(bool))
    }
}

extension SAtom {
    init(_ bool: Bool) {
        self = .symbol(bool ? "true" : "false")
    }
}