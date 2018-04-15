//
//  SToken.swift
//  LISPDefenders iOS
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

enum SToken {
    case whitespace
    case openParen
    case closeParen
    case atom(String)
}
