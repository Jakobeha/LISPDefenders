//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

struct SContext {
    static let base: SContext = SContext(
        valBinds: ["nil" : SExpr.list([])],
        macroBinds: [
            "λ" : { (args, ctx, evalExpr) in
                guard args.count == 2 else {
                    fatalError("λ: bad shape")
                }
                switch (args[0], args[1]) {
                case (.list(let lamArgExprs), let lamBody):
                    let lamArgs = lamArgExprs.map {
                        switch $0 {
                        case .atom(.symbol(let lamArg)):
                            return lamArg
                        default:
                            fatalError("λ: bad shape")
                        }
                    } as [String]
                    let semiEvalLamBody = evalExpr(lamBody, SContext(
                        valBinds: ctx.valBinds.filter { !lamArgs.contains($0.key) }
                    ))
                    return SExpr.list([SExpr.atom(.symbol("λ")), SExpr.list(lamArgExprs), semiEvalLamBody])
                default:
                    fatalError("λ: bad shape")
                }
            }, //Want to replace identifiers, but not eval functions, because they can crash
            "let" : { (args, ctx, evalExpr) in
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
                    return evalExpr(body, ctx + SContext(valBinds: parse(bindExprs: bindExprs)))
                default:
                    fatalError("let: bad shape")
                }
            },
            "if" : { (args, ctx, evalExpr) in
                guard args.count == 3 else {
                    fatalError("if: bad shape")
                }
                let pred = args[0]
                let ifTrue = args[1]
                let ifFalse = args[2]
                if evalExpr(pred, ctx).isTruthy {
                    return evalExpr(ifTrue, ctx)
                } else {
                    return evalExpr(ifFalse, ctx)
                }
            },
            "cond" : { (args, ctx, evalExpr) in
                return args.mapFirst({ clause in
                    switch clause {
                    case .list(let clauseArgs):
                        guard clauseArgs.count == 2 else {
                            fatalError("cond: bad shape")
                        }
                        let pred = clauseArgs[0]
                        let expr = clauseArgs[1]

                        guard pred == SExpr.atom(.symbol("else")) || evalExpr(pred, ctx).isTruthy else {
                            return nil
                        }
                        return evalExpr(expr, ctx)
                    default:
                        fatalError("cond: bad shape")
                    }
                }) ?? SExpr.list([])
            },
        ],
        funcBinds: [
            "'" : { SExpr.list($0) },
            "cons" : { args in
                guard args.count == 2 else {
                    fatalError("cons: bad arguments")
                }
                switch (args[0], args[1]) {
                case (let x, .list(let yContents)):
                    return SExpr.list([x] + yContents)
                default:
                    fatalError("cons: bad arguments")
                }
            },
            "first" : { args in
                guard args.count == 1 else {
                    fatalError("first: bad arguments")
                }
                switch args[0] {
                case .list(let contents):
                    guard contents.count > 0 else {
                        fatalError("first: bad arguments")
                    }
                    return contents.first!
                default:
                    fatalError("cons: bad arguments")
                }
            },
            "rest" : { args in
                guard args.count == 1 else {
                    fatalError("rest: bad arguments")
                }
                switch args[0] {
                case .list(let contents):
                    guard contents.count > 0 else {
                        fatalError("rest: bad arguments")
                    }
                    return SExpr.list(Array(contents.dropFirst()))
                default:
                    fatalError("rest: bad arguments")
                }
            },
            "+" : { args in
                guard args.count == 2 else {
                    fatalError("+: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr.atom(.number(xInt + yInt))
                case (let x, let y):
                    return SExpr.list([x, y])
                }
            },
            "-" : { args in
                guard args.count == 2 else {
                    fatalError("-: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr.atom(.number(xInt - yInt))
                case (let x, let y):
                    return SExpr.list([x, y])
                }
            },
            "*" : { args in
                guard args.count == 2 else {
                    fatalError("*: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr.atom(.number(xInt * yInt))
                case (.atom(.number(let xInt)), let y):
                    return SExpr.list(Array(repeating: y, count: xInt))
                case (let x, .atom(.number(let yInt))):
                    return SExpr.list(Array(repeating: x, count: yInt))
                default:
                    fatalError("*: bad arguments")
                }
            },
            "min" : { args in
                guard args.count == 2 else {
                    fatalError("min: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr.atom(.number(min(xInt, yInt)))
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    if xEmoji.effect < yEmoji.effect {
                        return SExpr.atom(.emoji(xEmoji))
                    } else {
                        return SExpr.atom(.emoji(yEmoji))
                    }
                case (let x, let y):
                    return SExpr.list([x, y])
                }
            },
            "max" : { args in
                guard args.count == 2 else {
                    fatalError("max: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr.atom(.number(max(xInt, yInt)))
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    if xEmoji.effect > yEmoji.effect {
                        return SExpr.atom(.emoji(xEmoji))
                    } else {
                        return SExpr.atom(.emoji(yEmoji))
                    }                case (let x, let y):
                    return SExpr.list([x, y])
                }
            },
            "and" : { args in
                for arg in args {
                    if !arg.isTruthy {
                        return arg
                    }
                }
                return SExpr.atom(.symbol("true"))
            },
            "or" : { args in
                for arg in args {
                    if arg.isTruthy {
                        return arg
                    }
                }
                return SExpr.atom(.symbol("false"))
            },
            "not" : { args in
                guard args.count == 1 else {
                    fatalError("not: bad arguments")
                }
                if args[0].isTruthy {
                    return SExpr.atom(.symbol("false"))
                } else {
                    return SExpr.atom(.symbol("true"))
                }
            },
            ">" : { args in
                guard args.count == 2 else {
                    fatalError(">: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect > yEmoji.effect)
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr(xInt > yInt)
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
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr(xInt < yInt)
                default:
                    fatalError("<: bad arguments")
                }
            },
            ">=" : { args in
                guard args.count == 2 else {
                    fatalError(">=: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect >= yEmoji.effect)
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr(xInt >= yInt)
                default:
                    fatalError(">=: bad arguments")
                }
            },
            "<=" : { args in
                guard args.count == 2 else {
                    fatalError("<=: bad arguments")
                }
                switch (args[0], args[1]) {
                case (.atom(.emoji(let xEmoji)), .atom(.emoji(let yEmoji))):
                    return SExpr(xEmoji.effect <= yEmoji.effect)
                case (.atom(.number(let xInt)), .atom(.number(let yInt))):
                    return SExpr(xInt <= yInt)
                default:
                    fatalError("<=: bad arguments")
                }
            },
            "=" : { args in
                guard args.count == 2 else {
                    fatalError("=: bad arguments")
                }
                return SExpr(args[0] == args[1])
            }
        ]
    )
    private static let empty: SContext = SContext()

    static func +(_ x: SContext, _ y: SContext) -> SContext {
        return SContext(
            valBinds: x.valBinds + y.valBinds,
            macroBinds: x.macroBinds + y.macroBinds,
            funcBinds: x.funcBinds + y.funcBinds
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

typealias MacroBind = ([SExpr], SContext, (SExpr, SContext) -> SExpr) -> SExpr
typealias FuncBind = ([SExpr]) -> SExpr
