//
//  Console.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation
 

public extension Console { 
    
    /// 测试某段代码执行耗时
    static func benchmark(_ work: @escaping () -> Void, completion: @escaping (Double) -> Void) {
        OCBenchmark(work, completion)
    }
}
