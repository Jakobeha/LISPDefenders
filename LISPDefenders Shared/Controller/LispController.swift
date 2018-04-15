//
//  LispController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/15/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreGraphics
#endif

class LispController {
    static let font: SKFont = SKFont(name: fontName, size: fontSize)!
    static let fontName: String = "Menlo"
    static let fontSize: CGFloat = 48
    
    static func boundsOf(expr: DLocdSExpr) -> CGSize {
        return (expr.print as NSString).size(withAttributes: [.font: LispController.font])
    }
    
    ///Gets the offset between parent and child, in the form of an "actual" position offset and a prefix
    ///for future calculations.
    static func childOffsets(
        childIdxOffset: Int,
        childLength: String.IndexDistance,
        fullPrint: String,
        fullHeight: CGFloat
    ) -> (CGSize, String) {
        let childIdx = fullPrint.index(fullPrint.startIndex, offsetBy: childIdxOffset)
        let childEndIdx = fullPrint.index(childIdx, offsetBy: childLength)
        var prefixIdx = childIdx
        var heightIdx = prefixIdx
        while prefixIdx > fullPrint.startIndex {
            heightIdx = fullPrint.index(before: prefixIdx)
            let prevChar = fullPrint[heightIdx]
            if prevChar == "\n" {
                break
            }
            prefixIdx = heightIdx
        }
        let heightText = fullPrint[fullPrint.startIndex ..< heightIdx]
        let prefixText = String(fullPrint[prefixIdx ..< childIdx])
        let childHeightText = String(fullPrint[prefixIdx ..< childEndIdx])
        let offsetSize = CGSize(
            width: (prefixText as NSString).size(withAttributes: [.font: LispController.font]).width,
            height: fullHeight -
                ((prefixIdx == fullPrint.startIndex) ? 0 : (heightText as NSString).size(withAttributes: [.font: LispController.font]).height) -
                (childHeightText as NSString).size(withAttributes: [.font: LispController.font]).height
        )
        return (offsetSize, prefixText)
    }
    
    var expr: DLocdSExpr { didSet {
        _size = LispController.boundsOf(expr: expr)
        _children = nil
        onSetExpr(expr)
    } }
    var posn: CGPoint { didSet {
        _children = nil
    } }
    private let onSetExpr: (DLocdSExpr) -> Void
    var size: CGSize {
        return _size
    }
    private let prefix: String
    private var _size: CGSize
    var isEvaluated: Bool
    
    var children: [LispController] {
        if _children == nil {
            _children = generateChildren()
        }
        return _children!
    }
    private var _children: [LispController]?
    
    var frame: CGRect {
        return CGRect(
            x: posn.x,
            y: posn.y,
            width: size.width,
            height: size.height
        )
    }
    
    var nonPrefixedPosn: CGPoint {
        let prefixWidth = (prefix as NSString).size(withAttributes: [.font: LispController.font]).width
        return CGPoint(x: posn.x - prefixWidth, y: posn.y)
    }
    
    ///Is the entire expression just an emoji?
    var isJustEmoji: Bool {
        switch expr.value {
        case .atom(.emoji(_)):
            return true
        default:
            return false
        }
    }
    
    init(
        expr: DLocdSExpr,
        posn: CGPoint,
        onSetExpr: @escaping (DLocdSExpr) -> Void = { _ in },
        prefix: String = "",
        isEvaluated: Bool = false
    ) {
        self.expr = expr
        self.posn = posn
        self.onSetExpr = onSetExpr
        self.prefix = prefix
        self.isEvaluated = isEvaluated
        _size = LispController.boundsOf(expr: expr)
    }
    
    private func generateChildren() -> [LispController] {
        switch expr.value {
        case .atom(_):
            return []
        case .list(let childExprs):
            let fullPrint = prefix + expr.print
            let nonPrefixedPosn = self.nonPrefixedPosn //Caches for speed
            
            return childExprs.enumerated().map { idxdChild in
                let (index, child) = idxdChild
                let (offsetSize, prefixText) = LispController.childOffsets(
                    childIdxOffset: prefix.count + Int(child.relLoc.idx),
                    childLength: child.print.count,
                    fullPrint: fullPrint,
                    fullHeight: size.height
                )
                return LispController(
                    expr: child,
                    posn: nonPrefixedPosn + offsetSize,
                    onSetExpr: { newChild in
                        var newChildExprs = childExprs
                        newChildExprs[index] = newChild
                        self.expr = self.expr.set(value: .list(newChildExprs))
                    },
                    prefix: prefixText,
                    isEvaluated: isEvaluated
                )
            }
        }
    }
}
