//
//  ObjectUnicode.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import UIKit

extension Array {
    
    var unicodeDescription: String {
        return description.stringByReplaceUnicode
    }
}

extension Dictionary {
    
    var unicodeDescription: String {
        return description.stringByReplaceUnicode
    }
}

extension String {
    
    var unicodeDescription: String {
        
        return stringByReplaceUnicode
    }
    
    var stringByReplaceUnicode: String {
        
        let tempStr1 = replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: .utf8)
        var returnStr = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\n", with: "\n")
    }
}
