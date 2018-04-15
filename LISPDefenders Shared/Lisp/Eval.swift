//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

extension SExpr {
    var emojiEval: [SEmojiEffect]? {
        return eval(context: SContext.base).toEmojis
    }

    var toEmojis: [SEmojiEffect]? {
        switch self {
        case .atom(let atom):
            return atom.toEmojis.map { [$0] }
        case .list(let contents):
            return contents.traverse { $0.toEmojis }?.flatMap { $0 }
        }
    }

    func eval(context: SContext) -> SExpr {
        func app(contents: [SExpr]) -> SExpr {
            guard !contents.isEmpty else {
                return .list(contents)
            }

            let head = contents.first!.eval(context: context)
            let args = contents.dropFirst()
            return macroApp(head: head, args: args) ??
                funcApp(head: head, args: args) ??
                lambdaApp(head: head, args: args) ??
                .list(contents)
        }

        func macroApp(head: SExpr, args: ArraySlice<SExpr>) -> SExpr? {
            guard let headBind = head.macroBind(context: context) else {
                return nil
            }

            return headBind(Array(args), { $0.eval(context: context + $1) })
        }

        func funcApp(head: SExpr, args: ArraySlice<SExpr>) -> SExpr? {
            guard let headBind = head.funcBind(context: context) else {
                return nil
            }

            return headBind(args.map { $0.eval(context: context) })
        }
        
        func lambdaApp(head: SExpr, args: ArraySlice<SExpr>) -> SExpr? {
            switch head {
            case .list(let headArgs):
                guard headArgs.count == 3 else {
                    return nil
                }
                switch (headArgs[0], headArgs[1], headArgs[2]) {
                case (.atom(.symbol("λ")), let lamArgsExpr, let lamBody):
                    let lamArgExprs = { switch lamArgsExpr {
                    case .list(let lamArgExprs):
                        return lamArgExprs
                    default:
                        fatalError("(λ ...): arguments not a list")
                        }
                    }() as [SExpr]
                    let lamArgs = lamArgExprs.map { lamArgExpr in
                        switch lamArgExpr {
                        case .atom(.symbol(let lamArg)):
                            return lamArg
                        default:
                            fatalError("(λ ...): argument not a symbol")
                        }
                    } as [String]
                    guard lamArgExprs.count == args.count else {
                        fatalError("(λ ...): wrong number of arguments")
                    }
                    let addedCtx = SContext(valBinds: Dictionary(uniqueKeysWithValues: Array.zipWith(
                        lamArgs,
                        Array(args),
                        combiner: { ($0, $1) }
                    )))
                    return lamBody.eval(context: context + addedCtx)
                default:
                    return nil
                }
            default:
                return nil
            }
        }

        switch self {
        case .atom(let atom):
            return atom.eval(context: context)
        case .list(let contents):
            return app(contents: contents)
        }
    }

    func macroBind(context: SContext) -> MacroBind? {
        switch self {
        case .atom(let atom):
            return atom.macroBind(context: context)
        case .list(_):
            return nil
        }
    }

    func funcBind(context: SContext) -> FuncBind? {
        switch self {
        case .atom(let atom):
            return atom.funcBind(context: context)
        case .list(_):
            return nil
        }
    }
}

extension SAtom {
    var toEmojis: SEmojiEffect? {
        switch self {
        case .symbol(_):
            return nil
        case .number(_):
            return nil
        case .emoji(let emoji):
            return emoji.effect
        }
    }

    func eval(context: SContext) -> SExpr {
        switch self {
        case .symbol(let symbol):
            return context.valBinds[symbol] ?? .atom(self)
        case .number(_):
            return .atom(self)
        case .emoji(_):
            return .atom(self)
        }
    }

    func macroBind(context: SContext) -> MacroBind? {
        switch self {
        case .symbol(let symbol):
            return context.macroBinds[symbol]
        case .number(_):
            return nil
        case .emoji(_):
            return nil
        }
    }

    func funcBind(context: SContext) -> FuncBind? {
        switch self {
        case .symbol(let symbol):
            return context.funcBinds[symbol]
        case .number(_):
            return nil
        case .emoji(_):
            return nil
        }
    }
}
