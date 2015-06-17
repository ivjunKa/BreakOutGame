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
    let name: String?
    init(name: String){
        self.name = name
    }
    func applyBonus(game: GameScene){
        
    }
    func dismissBonus(game: GameScene){
        
    }
    class BIGGER_PADDLE: BonusType {
            override func applyBonus(game: GameScene) {
                for nodes in game.children {
                    var node = nodes as SKNode
                    if node.name == "paddle" {
                        game.game!.countDownBonus = 5.0
                        game.getCurrentTime = true
                        game.startCountDownBonus = true
                        node.xScale = 2
                    }
                }
            }
            override func dismissBonus(game: GameScene){
                for nodes in game.children {
                    var node = nodes as SKNode
                    if node.name == "paddle" {
                        node.xScale /= 2
                    }
                }
            }
    }
    class EXTRA_LIVE: BonusType {
        override func applyBonus(game: GameScene) {
            game.game!.livesCount++
        }
    }
    
}
