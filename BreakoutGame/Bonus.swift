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
    var bonusType : String?
    init(bonusType: String){
        self.bonusType = bonusType
        let texture = SKTexture(imageNamed: Bonus.getSpriteNode(bonusType))
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        getBonusType(bonusType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func getSpriteNode(bonusType: String) ->String{
        switch bonusType {
        case "bigger_paddle":
            return "bonus_bigger_paddle"
        case "extra_life":
            return "bonus_extra_life"
        default: return "bonus_bigger_paddle"
        }
    }
    func getBonusType(bonusType: String){
        switch bonusType{
            case "bigger_paddle":
                self.bType = BonusType.BIGGER_PADDLE(name: "Big Paddle")
            case "extra_life":
            self.bType = BonusType.EXTRA_LIVE(name: "Extra Life")
            default: self.bType = BonusType.BIGGER_PADDLE(name: "Big Paddle")
        }
    }
}
