//
//  Parse.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

extension Template {
    static func parse(fileWithName name: String) -> Template {
        return Template.parse(SExpr.parse(try! String(contentsOf: Bundle.main.url(forResource: name, withExtension: "lisp")!)))
    }
    
    static func parse(_ sexprs: [DLocdSExpr]) -> Template {
        return Template(items: sexprs.map(TemplateItem.parse))
    }
}

extension TemplateItem {
    static func parse(_ sexpr: DLocdSExpr) -> TemplateItem {
        switch sexpr.value {
        case .list(let args):
            guard args.count == 3 else {
                fatalError("template: bad shape")
            }
            switch (args[0].deepValue, args[1].deepValue, args[2]) {
            case (.atom(.symbol("template")), .atom(.number(let frequency)), let expr):
                return TemplateItem(expr: expr, frequency: frequency)
            default:
                fatalError("template: bad shape")
            }
        default:
            fatalError("template: bad shape")
        }
    }
}

extension SExpr {
    static func parse(_ str: String) -> [DLocdSExpr] {
        return SExpr.parse(SToken.lex(str))
    }

    static func parse(_ tokens: [Locd<SToken>]) -> [DLocdSExpr] {
        // Locations aren't actually unused
        var curLists: [DLocd<[DLocdSExpr]>] = [DLocd([], print: "", absLoc: Loc.start, relLoc: Loc.start)]
        var curParentAbsLoc: Loc = Loc.start

        func push(expr: DLocdSExpr) {
            guard !curLists.isEmpty else {
                fatalError("Invalid expression - extra close paren")
            }

            var last = curLists.popLast()!
            last.value.append(expr)
            last.print += expr.print
            curLists.append(last)
        }
        
        func push(whitespace: String) {
            guard !curLists.isEmpty else {
                fatalError("Invalid expression - extra close paren")
            }
            
            var last = curLists.popLast()!
            last.print += whitespace
            curLists.append(last)
        }

        for token in tokens {
            switch token.value {
            case .whitespace:
                push(whitespace: token.print)
            case .openParen:
                curLists.append(DLocd(
                    [],
                    print: token.print,
                    absLoc: token.location,
                    relLoc: token.location - curParentAbsLoc
                ))
                curParentAbsLoc = token.location
            case .closeParen:
                guard !curLists.isEmpty else {
                    fatalError("Invalid expression - extra close paren")
                }

                let list = curLists.popLast()!
                let expr = DLocdSExpr.list(
                    list.value,
                    print: list.print + token.print,
                    absLoc: list.absLoc,
                    relLoc: list.relLoc
                )
                push(expr: expr)
                curParentAbsLoc = curLists.last!.absLoc
            case .atom(let content):
                let atom = SAtom.parse(content)
                let expr = DLocdSExpr.atom(
                    atom,
                    print: token.print,
                    absLoc: token.location,
                    relLoc: token.location - curParentAbsLoc
                )
                push(expr: expr)
            }
        }

        guard curLists.count == 1 else {
            fatalError("Invalid expression - extra open parens")
        }

        return curLists.first!.value
    }
}

extension SAtom {
    static func parse(_ content: String) -> SAtom {
        if let int = Int(content) {
            return .number(int)
        } else if let emoji = SEmoji.parse(content) {
            return .emoji(emoji)
        } else {
            return .symbol(content)
        }
    }
}

extension SEmoji {
    static func parse(_ content: String) -> SEmoji? {
        guard content.count == 1 else {
            return nil
        }
        
        return SEmoji.charToEmoji[content.first!]
    }
}
