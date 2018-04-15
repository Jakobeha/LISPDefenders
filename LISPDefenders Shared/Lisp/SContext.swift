//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

struct SContext {
    static let base: SContext = SContext(
        valBinds: ["nil" : SExpr.list([])],
        macroBinds: [
            "let" : { (args, evalExpr) in
                func parse(bindExprs: [SExpr]) -> [String : SExpr] {
                    return Dictionary(uniqueKeysWithValues: bindExprs.map(parse))
                }

                func parse(bindExpr: SExpr) -> (String, SExpr) {
                    switch bindExpr {
                    case .list(let bindArgs):
                        guard bindArgs.count == 2 else {
                            fatalError("let: bad shape")
                        }
                        switch (bindArgs[0], bindArgs[1]) {
                        case (.atom(.symbol(let binding)), let bound):
                            return (binding, bound)
                        default:
                            fatalError("let: bad shape")
                        }
                    default:
                        fatalError("let: bad shape")
                    }
                }

                guard args.count == 2 else {
                    fatalError("let: bad shape")
                }
                switch (args[0], args[1]) {
                case (.list(let bindExprs), let body):
                    return evalExpr(body, SContext(valBinds: parse(bindExprs: bindExprs)))
                default:
                    fatalError("let: bad shape")
                }
            },
            "if" : { (args, evalExpr) in
                guard args.count == 3 else {
                    fatalError("if: bad shape")
                }
                let pred = args[0]
                let ifTrue = args[1]
                let ifFalse = args[2]
                if evalExpr(pred, SContext.empty).isTruthy {
                    return evalExpr(ifTrue, SContext.empty)
                } else {
                    return evalExpr(ifFalse, SContext.empty)
                }
            },
            "cond" : { (args, evalExpr) in
                guard let res = args.mapFirst({ clause in
                    switch clause {
                    case .list(let clauseArgs):
                        guard clauseArgs.count == 2 else {
                            fatalError("cond: bad shape")
                        }
                        let pred = clauseArgs[0]
                        let expr = clauseArgs[1]

                        guard pred == SExpr.atom(.symbol("else")) || evalExpr(pred, SContext.empty).isTruthy else {
                            return nil
                        }
                        return evalExpr(expr, SContext.empty)
                    default:
                        fatalError("cond: bad shape")
                    }
                }) as SExpr? else {
                    fatalError("cond: bad shape")
                }

                return res
            }
        ],
        funcBinds: [
            "'" : { SExpr.list($0) },
            "*" : { args in
                guard args.count == 2 else {
                    fatalError("*: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.number(let xInt)), let y):
                    return SExpr.list(Array(repeating: y, count: xInt))
                default:
                    fatalError("*: bad arguments")
                }
            },
            ">" : { args in
                guard args.count == 2 else {
                    fatalError(">: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect > yEmoji.effect)
                default:
                    fatalError(">: bad arguments")
                }
            },
            "<" : { args in
                guard args.count == 2 else {
                    fatalError("<: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect < yEmoji.effect)
                default:
                    fatalError("<: bad arguments")
                }
            },
            ">=" : { args in
                guard args.count == 2 else {
                    fatalError(">: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect >= yEmoji.effect)
                default:
                    fatalError(">: bad arguments")
                }
            },
            "<=" : { args in
                guard args.count == 2 else {
                    fatalError("<=: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect <= yEmoji.effect)
                default:
                    fatalError("<=: bad arguments")
                }
            },
            ">" : { args in
                guard args.count == 2 else {
                    fatalError(">=: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect >= yEmoji.effect)
                default:
                    fatalError(">=: bad arguments")
                }
            },
            "=" : { args in
                guard args.count == 2 else {
                    fatalError("=: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect == yEmoji.effect)
                default:
                    fatalError("=: bad arguments")
                }
            }
        ]
    )
    private static let empty: SContext = SContext()

    static func +(_ x: SContext, _ y: SContext) -> SContext {
        return SContext(
            valBinds: try! (x.valBinds + y.valBinds),
            macroBinds: try! (x.macroBinds + y.macroBinds),
            funcBinds: try! (x.funcBinds + y.funcBinds)
        )
    }

    let valBinds: [String : SExpr]
    let macroBinds: [String : MacroBind]
    let funcBinds: [String : FuncBind]

    init(valBinds: [String : SExpr] = [:], macroBinds: [String : MacroBind] = [:], funcBinds: [String : FuncBind] = [:]) {
        self.valBinds = valBinds
        self.macroBinds = macroBinds
        self.funcBinds = funcBinds
    }
}

typealias MacroBind = ([SExpr], (SExpr, SContext) -> SExpr) -> SExpr
typealias FuncBind = ([SExpr]) -> SExpr
