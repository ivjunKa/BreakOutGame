//
//  Brick.swift
//  BreakoutGame
//
//  Created by Home on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation
import SpriteKit

class Brick : SKSpriteNode{
    
    let brickType: BrickType?
    var hitCount: Int = 0
    let bonus: Bonus?
    var brickDestroyedImg: String?
    
    init(spriteNodeName: String, brickType: BrickType, bonusAdded: Bool){
        let texture = SKTexture(imageNamed: Brick.getSpriteNode(spriteNodeName))
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        if bonusAdded {
            bonus = Bonus(bonusType: Brick.generateBonusType())
        }
        
        self.brickType = brickType
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onHit(game: GameBrain ) -> Bool{
        hitCount++
        brickType!.onHit(self,game:game)
        return brickType!.getMaxHits() <= hitCount
    }
    
    func onBreak(game: GameBrain) -> Void{
        
    }
    
    func getPoints() -> Int {
        return brickType!.getPoints()
    }
    
    class func getSpriteNode(brickType: String) -> String{
        switch brickType {
        case "normal" :
            return "brickwhite"
        default:
            return "brickwhite"
        }
    }
    class func generateBonusType() -> String {
            switch arc4random()%5 {
            case 0: return "bigger_paddle"
            case 1: return "extra_life"
            default: return "bigger_paddle"
            }
    }
}
