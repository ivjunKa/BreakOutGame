//
//  Brick.swift
//  BreakoutGame
//
//  Created by Home on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation
import SpriteKit

class Bonus : SKSpriteNode{
    var bType: BonusType?
    
    init(bonusType: String){
        let texture = SKTexture(imageNamed: Bonus.getSpriteNode(bonusType))
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func getSpriteNode(bonusType: String) ->String{
        switch bonusType {
        case "extra_ball":
            
            return "bonus_extra_ball"
        default: return "bonus_extra_ball"
        }
    }
}
