//
//  HUD+Sync.swift
//  PROJECT
//
//  Created by 李阳 on 2023/12/9.
//

import Foundation


protocol Request {
}
enum NextRequestControl {
    case remove
    case removeSuccessors
    case goon
}

fileprivate var requestMap: NSMutableDictionary = .init()

protocol SyncRequestManager {
    associatedtype RequestType: Request
    typealias Action = Int
    typealias RequestTag = Int
    
    static func processRequest(_ request: RequestType,
                               tag: RequestTag,
                               onFinished: @escaping (_ request: RequestType, _ action: Action) -> Void)
     
    typealias FinishInfo = (request: RequestType, tag: RequestTag, action: Action)
    typealias FinshAndNextControl = (_ this: FinishInfo, _ next: RequestTag?) -> NextRequestControl?
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
                                   tag: RequestTag,
                                   closure: FinshAndNextControl)? {
        items.firstObject as? (() -> RequestType, RequestTag, FinshAndNextControl)
    }
    
    static func request(tag: RequestTag,
                        build: @escaping () -> RequestType,
                        onFinished: @escaping FinshAndNextControl) {
        let isEmpty = items.isEmpty
        items.add((build, tag, onFinished))
        if isEmpty {
            process(build(), tag: tag, onFinished: onFinished)
        }
    }
    private static func process(_ reqest: RequestType, tag: RequestTag, onFinished: @escaping FinshAndNextControl) {
        processRequest(reqest, tag: tag) { req, action in
            items.removeObject(at: 0)
            guard let next = firstItem else {
                let _ = onFinished((req, tag, action), nil)
                return
            }
            let control = onFinished((req, tag, action), next.tag) ?? .goon
            switch control {
            case .remove:
                items.removeObject(at: 0)
                guard let item = firstItem else {
                    return
                }
                process(item.request(), tag: item.tag, onFinished: item.closure)
            case .removeSuccessors:
                items.removeAllObjects()
            case .goon:
                process(next.request(), tag: next.tag, onFinished: next.closure)
            }
        }
    }
}
