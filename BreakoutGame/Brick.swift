//
//  Brick.swift
//  BreakoutGame
//
//  Created by Home on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation
import SpriteKit

class Brick {
    
    let spriteNode: SKSpriteNode?
    let brickType: BrickType?
    let hitCount: Int?
    
    init(spriteNodeName: String, brickType: BrickType){
        self.brickType = brickType
        self.spriteNode = getSpriteNode(spriteNodeName)
        
    }
    func onHit(level: Level ) -> Bool{
        return brickType!.onHit(self,level:level)
    }
    func getSpriteNode(brickType: String) -> SKSpriteNode{
        switch brickType {
        case "normal" :
            return SKSpriteNode(imageNamed: "brickwhite")
        default:
            return SKSpriteNode(imageNamed: "brickwhite")
        }
    }
}
