//
//  GOMO.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//

import Foundation

public struct GOMO<Base> {
    public internal(set) var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol GOMOCompatible {}

public extension GOMOCompatible {
    var go: GOMO<Self> {
        get { return GOMO(self) }
        set { self = newValue.base }
    }
    static var go: GOMO<Self>.Type {
        get { return GOMO<Self>.self }
        set {  }
    }
}

