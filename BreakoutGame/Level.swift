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
    
    var gameBounds:CGSize?
    var levelName: String?
    var nrOfRows:Int?
    var nrOfCols:Int?

    let brickBitmask:UInt32 = 3
    
    var padding:CGFloat?
    var colWidth:CGFloat?
    var bricks: Array<Brick>?
    
    var background: SKSpriteNode?
    
    init(levelName name: String, gameBounds: CGSize){
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
            self.background = SKSpriteNode(imageNamed: "bgwall")
            var colWidth = SKSpriteNode(imageNamed: "brickwhite").size.width
            var totalColWidth = (CGFloat(nrOfCols!) * colWidth)
            var totalPaddingWidth = (CGFloat(nrOfCols! - 1)) * padding!
            var offsetX = (gameBounds!.width - (totalColWidth + CGFloat(totalPaddingWidth)))/2
//            var offsetY: CGFloat = 100
            var offsetY: CGFloat = gameBounds!.height / 3
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
                    brick.physicsBody?.categoryBitMask = brickBitmask
                    brick.physicsBody?.collisionBitMask = 0
                    brick.physicsBody?.dynamic = false
                    bricks!.append(brick)
                    nextColPos! += colWidth + padding!
                }
            }
            //end level 1-1
        case "1-2":
            self.nrOfRows = 3
            self.nrOfCols = 4
            self.padding = 20
            self.bricks = Array<Brick>()
            self.background = SKSpriteNode(imageNamed: "background_green")
            var colWidth = SKSpriteNode(imageNamed: "brickwhite").size.width
            var totalColWidth = (CGFloat(nrOfCols!) * colWidth)
            var totalPaddingWidth = (CGFloat(nrOfCols! - 1)) * padding!
            var offsetX = (gameBounds!.width - (totalColWidth + CGFloat(totalPaddingWidth)))/2
//            var offsetY: CGFloat = 100
            var offsetY: CGFloat = gameBounds!.height / 3
            var nextColPos: CGFloat?
            
            for index in 1...nrOfRows! {
                offsetY += 50
                nextColPos = 0
                for index in 1...nrOfCols! {
                    let brick : Brick = Brick(spriteNodeName: "normal", brickType: index == 1 ? BrickType.BONUS : BrickType.NORMAL,bonusAdded: true)
                    if index%2 == 0{
                        nextColPos! += 60
                    }
                    brick.position = CGPointMake(offsetX + nextColPos!,offsetY)
                    brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
                    brick.physicsBody?.allowsRotation = false
                    brick.physicsBody?.friction = 0
                    //TODO replace name of the sprite node with brick category
                    brick.name = "brickwhite"
                    brick.physicsBody?.categoryBitMask = brickBitmask
                    brick.physicsBody?.collisionBitMask = 0
                    brick.physicsBody?.dynamic = false
                    bricks!.append(brick)
                    nextColPos! += colWidth + padding!
                }
            }
            // end level 1-2
        default: println("1-2")
        }
    }
    
    func getBricksStructure()->Array<Brick>{
        return self.bricks!
    }
    func getBackground() -> SKSpriteNode{
        return self.background!
    }
}