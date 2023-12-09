//
//  HUD+Sync.swift
//  PROJECT
//
//  Created by 李阳 on 2023/12/9.
//

import Foundation


protocol Request {
    var tag: Int { get }
}
enum NextRequestControl {
    case remove
    case removeSuccessors
    case goon
}

fileprivate var requestMap: NSMutableDictionary = .init()

protocol SyncRequestManager {
    associatedtype RequestType: Request
     
    static func processRequest(_ request: RequestType, onFinished: @escaping (_ request: RequestType, _ action: Int) -> Void)
     
    typealias FinishInfo = (request: RequestType, action: Int)
    typealias FinshAndNextControl = (_ this: FinishInfo, _ next: RequestType?) -> NextRequestControl?
}
fileprivate extension NSMutableArray {
    var isEmpty: Bool { count == 0 }
    @discardableResult
    func removeFirst() -> Any? {
        if count == 0 { return nil }
        let obj = object(at: 0)
        removeObject(at: 0)
        return obj
    }
}
extension SyncRequestManager {
    private static var items: NSMutableArray {
        let key = String(describing: self)
        if let arr = requestMap[key] as? NSMutableArray {
            return arr
        }
        let arr = NSMutableArray()
        requestMap[key] = arr
        return arr
    }
    private static var firstItem: (request: () -> RequestType,
                                  closure: FinshAndNextControl)? {
        items.firstObject as? (() -> RequestType, FinshAndNextControl)
    }
    
    static func request(_ requestBuild: @escaping () -> RequestType, onFinished: @escaping FinshAndNextControl) {
        let isEmpty = items.isEmpty
        items.add((requestBuild, onFinished))
        if isEmpty {
            process(requestBuild(), onFinished: onFinished)
        }
    }
    private static func process(_ reqest: RequestType, onFinished: @escaping FinshAndNextControl) {
        processRequest(reqest) { req, action in
            items.removeObject(at: 0)
            guard let nextItem = firstItem else {
                let _ = onFinished((req, action), nil)
                return
            }
            let nextReq = nextItem.0()
            let control = onFinished((req, action), nextReq) ?? .goon
            switch control {
            case .remove:
                items.removeObject(at: 0)
                guard let next = firstItem else {
                    return
                }
                process(next.0(), onFinished: next.1)
            case .removeSuccessors:
                items.removeAllObjects()
            case .goon:
                process(nextReq, onFinished: nextItem.1)
            }
        }
    }
}
