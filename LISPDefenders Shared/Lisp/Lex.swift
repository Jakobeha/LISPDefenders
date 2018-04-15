//
//  Lex.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

extension SToken {
    static func lex(_ str: String) -> [Locd<SToken>] {
        var tokens = [] as [Locd<SToken>]
        var curAtom = ""
        var location = Loc.start

        func endAtom() {
            if (curAtom != "") {
                tokens.append(Locd(
                    .atom(curAtom),
                    print: curAtom,
                    location: Loc(idx: location.idx - UInt(curAtom.count))
                ))
            }
            curAtom = ""
        }

        for char in str {
            switch char {
            case " ", "\t":
                endAtom()
                tokens.append(Locd(.whitespace, print: String(char), location: location))
                location.addColumn()
            case "\n":
                endAtom()
                tokens.append(Locd(.whitespace, print: String(char), location: location))
                location.addLine()
            case "(", "[", "{":
                endAtom()
                tokens.append(Locd(.openParen, print: String(char), location: location))
                location.addColumn()
            case ")", "]", "}":
                endAtom()
                tokens.append(Locd(.closeParen, print: String(char), location: location))
                location.addColumn()
            default:
                curAtom.append(char)
                location.addColumn()
            }
        }

        endAtom()

        return tokens
    }
}
