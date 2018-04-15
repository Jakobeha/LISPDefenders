//
//  Random.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation
#if os(iOS)
    import CoreGraphics
#endif

class Random {
    static func within(min: CGFloat, max: CGFloat) -> CGFloat {
        return (Random.getFraction() * (max - min)) + min
    }
    
    static func within(min: Double, max: Double) -> Double {
        return (Double(Random.getFraction()) * (max - min)) + min
    }
    
    static func getFraction() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
    
    static func choice<T>(_ weightsAndItems: [(CGFloat, T)]) -> T {
        let weights = weightsAndItems.map { $0.0 }
        let items = weightsAndItems.map { $0.1 }
        let idx = Random.choiceIdx(weights)
        return items[idx]
    }
    
    static func choiceIdx(_ weights: [CGFloat]) -> Int {
        let total = weights.reduce(0, { $0 + $1 })
        let frac = Random.within(min: 0, max: total)
        
        var curWeight = 0 as CGFloat
        var idx = 0 as Int
        for weight in weights {
            curWeight += weight
            if curWeight >= frac {
                return idx
            }
            idx += 1
        }
        
        fatalError("Couldn't make a choice - probably no weights given.")
    }
}
