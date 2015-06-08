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
    let brickType: String?
    var hitCount: Int?
    
    init(brickType: String){
        
        spriteNode = getSprite(brickType)
        
    }
    func getSprite(brickType: String) -> SKSpriteNode{
        switch brickType {
        case "normal" : return SKSpriteNode(imageNamed: "brickwhite")
        default: return SKSpriteNode(imageNamed: "brickwhite")
        }
    }
}
