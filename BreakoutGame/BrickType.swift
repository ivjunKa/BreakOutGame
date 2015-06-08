//
//  PaddleType.swift
//  BreakoutGame
//
//  Created by Mad Max on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation

class BrickType {
    private let points: Int
    private let maxHits: Int
        
    private init(_ maxHit:Int, points p: Int) {
        self.maxHits = maxHit
        self.points = p
    }
        
    func onHit(brick: Brick, level: Level) ->(Bool) {return true}
    
    class var NORMAL: BrickType {
        class Normal: BrickType {
            override func onHit(brick: Brick, level: Level) ->(Bool) {
                return true;
            }
        }
        return Normal(1, points: 10)
    }
    
    class var DOUBLE: BrickType {
        class DoublePoints: BrickType {
            override func onHit(brick: Brick, level: Level) -> (Bool) {
                return brick.hitCount == maxHits
            }
        }
        return DoublePoints(2, points: 20)
    }
    
    class var EXTRA_BALL: BrickType {
        class Extra_Ball: BrickType {
            override func onHit(brick: Brick, level: Level) -> (Bool) {
                
                return true
            }
        }
        return Extra_Ball(1, points: 10)
    }
    
    class func CUSTOM(maxHit: Int, points: Int) -> BrickType {
        return BrickType(maxHit, points: points)
    }
}

func == (lhs: BrickType, rhs: BrickType) -> Bool {
    return lhs.maxHits == rhs.maxHits
}