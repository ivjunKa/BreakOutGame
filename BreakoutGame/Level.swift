//
//  Level.swift
//  BreakoutGame
//
//  Created by Mad Max on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation
import SpriteKit

class Level {
    
    var gameBounds:CGFloat?
    var levelName: String?
    var nrOfRows:Int?
    var nrOfCols:Int?

    
    var padding:CGFloat?
    var colWidth:CGFloat?
    var bricks: Array<Brick>?
    
    init(levelName name: String, gameBounds: CGFloat){
        self.levelName = name
        self.gameBounds = gameBounds
        prepareLevelStructure(self.levelName!)
    }
    func getLevelName() -> String {
        return levelName!
    }
    func prepareLevelStructure(levelName: String){
        switch levelName {
        case "1-1":
            self.nrOfRows = 3
            self.nrOfCols = 3
            self.padding = 20
            self.bricks = Array<Brick>()
            var colWidth = SKSpriteNode(imageNamed: "brickwhite").size.width
            var totalColWidth = (CGFloat(nrOfCols!) * colWidth)
            var totalPaddingWidth = (CGFloat(nrOfCols! - 1)) * padding!
            var offsetX = (gameBounds! - (totalColWidth + CGFloat(totalPaddingWidth)))/2
            var offsetY: CGFloat = 100
            var nextColPos: CGFloat?
            
            for index in 1...nrOfRows! {
                offsetY += 50
                nextColPos = 0
                for index in 1...nrOfCols! {
                    let brick : Brick = Brick(spriteNodeName: "normal", brickType: index == 1 ? BrickType.BONUS : BrickType.NORMAL,bonusAdded: true)
                    brick.position = CGPointMake(offsetX + nextColPos!,offsetY)
                    brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
                    brick.physicsBody?.allowsRotation = false
                    brick.physicsBody?.friction = 0
                    //TODO replace name of the sprite node with brick category
                    brick.name = "brickwhite"
//                    brick.physicsBody?.categoryBitMask = brickBitmask
                    brick.physicsBody?.collisionBitMask = 0
                    brick.physicsBody?.dynamic = false
//                    self.addChild(brick)
                    bricks!.append(brick)
                    nextColPos! += colWidth + padding!
                }
            }
        default: println("1-1")
        }
    }
    
    func getBricksStructure()->Array<Brick>{
        return self.bricks!
    }
}