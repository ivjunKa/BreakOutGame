//
//  PaddleType.swift
//  BreakoutGame
//
//  Created by Mad Max on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation

class BrickType {
    class Store: Equatable {
        let maxHits: Int
        
        init(_ maxHits:Int) {
            self.maxHits = maxHits
        }
        
        func onHit(brick: Brick, level: Level) ->(Bool) {return true}
        
    }
    
    class var NORMAL: Store {
        class Normal: Store {
            override func onHit(brick: Brick, level: Level) ->(Bool) {
                println("Attack with shuriken.")
                return true;
            }
        }
        return Normal(1)
    }
    
    class var DOUBLE: Store {
        class DoublePoints: Store {
            override func onHit(brick: Brick, level: Level) -> (Bool) {
                println("Attack with sword.")
                return true;
            }
        }
        return DoublePoints(2)
    }
    
    class func CUSTOM(salary: Int) -> Store {
        return Store(salary)
    }
}

func == (lhs: BrickType.Store, rhs: BrickType.Store) -> Bool {
    return lhs.maxHits == rhs.maxHits
}