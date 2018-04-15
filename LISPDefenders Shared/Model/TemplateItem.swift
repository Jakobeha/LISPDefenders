//
//  TemplateItem.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreGraphics
#endif

struct TemplateItem {
    let expr: DLocdSExpr
    let unscaledFrequency: Int
    let scaledFrequency: Int
    
    func frequency(difficultyScale: CGFloat) -> CGFloat {
        return max(0, CGFloat(unscaledFrequency) + (CGFloat(scaledFrequency) * difficultyScale))
    }
}
