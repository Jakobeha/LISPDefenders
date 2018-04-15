//
//  CGFloat.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/15/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreGraphics
#endif

extension CGFloat {
    static func clamp(_ x: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        if x < min {
            return min
        } else if x > max {
            return max
        } else {
            return x
        }
    }
}
