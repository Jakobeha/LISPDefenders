//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

enum UnDLocdSExpr {
    case atom(SAtom)
    case list([DLocdSExpr])

    var deepValue: SExpr {
        switch self {
        case .atom(let atom):
            return .atom(atom)
        case .list(let contents):
            return .list(contents.map { $0.deepValue })
        }
    }
}

typealias DLocdSExpr = DLocd<UnDLocdSExpr>

extension DLocd where T == UnDLocdSExpr {
    static func atom(_ value: SAtom, print: String, absLoc: Loc, relLoc: Loc) -> DLocdSExpr {
        return DLocd(UnDLocdSExpr.atom(value), print: print, absLoc: absLoc, relLoc: relLoc)
    }

    static func list(_ contents: [DLocdSExpr], print: String, absLoc: Loc, relLoc: Loc) -> DLocdSExpr {
        return DLocd(UnDLocdSExpr.list(contents), print: print, absLoc: absLoc, relLoc: relLoc)
    }
    
    static func translatePrint(_ print: String, oldValue: UnDLocdSExpr, newValue: UnDLocdSExpr) -> String {
        switch (oldValue, newValue) {
        case (_, .atom(let newAtom)):
            return newAtom.print
        case (.atom(_), .list(_)):
            fatalError("Can't translate from an atom to a list - information is lost.")
        case (.list(let oldContents), .list(let newContents)):
            guard oldContents.count == newContents.count else {
                fatalError("Can't translate between lists of different length - information is lost.")
            }
            
            var curPrint = print
            for (oldItem, newItem) in Array.zipWith(oldContents, y: newContents, reducer: { ($0, $1) }) {
                guard oldItem.print.count == newItem.print.count else {
                    fatalError("Can't translate between lists with elements of different print length - information is lost.")
                }
                curPrint = curPrint.replacingCharacters(in: oldItem.printRange(in: curPrint), with: newItem.print)
            }
            return curPrint
        }
    }

    var deepValue: SExpr {
        return value.deepValue
    }
    
    func printRange(in string: String) -> Range<String.Index> {
        let start = string.index(string.startIndex, offsetBy: Int(relLoc.idx))
        let end = string.index(start, offsetBy: print.count)
        return start ..< end
    }
    
    func set(value: UnDLocdSExpr) -> DLocdSExpr {
        return DLocd(
            value,
            print: DLocdSExpr.translatePrint(print, oldValue: self.value, newValue: value),
            absLoc: absLoc,
            relLoc: relLoc
        )
    }
    
    
}
