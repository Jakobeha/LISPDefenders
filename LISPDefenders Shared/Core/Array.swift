//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

extension Array {
    static func zipWith<T1, T2>(_ x: [T1], _ y: [T2], combiner: (T1, T2) -> Element) -> [Element] {
        var res = [] as [Element]
        var i = 0
        while i < x.count && i < y.count {
            res.append(combiner(x[i], y[i]))
            i += 1
        }
        return res
    }
    
    func traverse<T2>(_ f: (Element) throws -> T2?) rethrows -> [T2]? {
        let inter = try map(f)
        guard !inter.contains(where: { $0 == nil }) else {
            return nil
        }

        return inter.map { $0! }
    }

    func mapFirst<T2>(_ f: (Element) throws -> T2?) rethrows -> T2? {
        return try map(f).first(where: { $0 != nil }).map { $0! }
    }
}

extension Array where Element: AnyObject {
    func index(of elem: Element) -> Index? {
        return index(where: { $0 === elem })
    }
}
