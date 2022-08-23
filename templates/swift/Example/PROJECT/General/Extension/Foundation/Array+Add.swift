//
//  Array+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation

// https://www.jianshu.com/p/f501e465d1c4
extension Array {
    /**
     let nums: [[Int]] = [
         [1, 2, 3, 4, 5],
         [11, 12, 13, 14],
         [101, 102, 103, 104, 105, 106]
     ]
     let nums2 = nums.verticalMap()
     print(nums2)
     [1, 11, 101, 2, 12, 102, 3, 13, 103, 4, 14, 104, 5, 105, 106]
     */
    func verticalMap() -> [Element.Element] where Element: Collection, Element.Index == Int {
        guard let maxCount = self.max(by: { $0.count < $1.count })?.count else { return [] }
        let n = count
        var res: [Element.Element] = []
        for i in 0..<maxCount {
            for j in 0..<n {
                let item = self[j]
                guard i < item.count else { continue }
                res.append(item[i])
            }
        }
        return res
    }
}
