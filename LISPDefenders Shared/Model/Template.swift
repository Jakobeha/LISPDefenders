//
//  Template.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreGraphics
#endif

struct Template {
    let items: [TemplateItem]
    
    func getNextExpr() -> DLocdSExpr {
        return Random.choice(items.map { item in (CGFloat(item.frequency), item.expr) })
    }
}
