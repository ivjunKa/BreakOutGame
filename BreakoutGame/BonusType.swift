//
//  BonusType.swift
//  BreakoutGame
//
//  Created by Home on 16/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation
import SpriteKit
class BonusType {
    init(){
       println("bonus type created")
    }
    func applyBonus(game: GameScene){
        println("some kind of bonus needs to be applied here")        
    }
    class BIGGER_PADDLE: BonusType {
            override func applyBonus(game: GameScene) {
                for nodes in game.children {
                    var node = nodes as SKNode
                    if node.name == "paddle" {
                        node.xScale = 2
                    }
                }
            }
    }
    
}
