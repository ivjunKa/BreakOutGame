//
//  GameScene.swift
//  BreakoutGame
//
//  Created by Home on 06/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var game: GameBrain?
    
    var touchingTheScreen = false
    
    var balCatName = "ball"
    var brickCatName = "brickwhite"
    var paddleCatName = "paddle"
    
//    let balBitmask:UInt32 = 0x1 << 0
//    let bottomBorderBitmask:UInt32 = 0x1 << 1
//    let brickBitmask:UInt32 = 0x1 << 2
//    let paddleBitmask:UInt32 = 0x1 << 3

    let balBitmask:UInt32 = 1
    let bottomBorderBitmask:UInt32 = 2
    let brickBitmask:UInt32 = 3
    let paddleBitmask:UInt32 = 4
    
    override init(size: CGSize){
        super.init(size: size)
        
        game = GameBrain()
        
        //adding delegate to detect collision
        self.physicsWorld.contactDelegate = self
        //creating and adding backround image
        let backgroundImage = SKSpriteNode(imageNamed: "bgwall")
        backgroundImage.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(backgroundImage)
        
        //disable standart gravity
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        //creating game boundaries and adjusting them size of our frame
        let gameBoundaries = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = gameBoundaries
        
        //disable friction so the ball doesn`t slow down while touching the boundarys of the game
        self.physicsBody?.friction = 0
        
        //creating an ball from image
        let ball = SKSpriteNode(imageNamed: balCatName)
        ball.name = balCatName
        ball.position = CGPointMake(self.frame.midX, self.frame.midY - 120)
        self.addChild(ball)
        
        //creating the physics body for the ball so it can "communicate" with the world
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody?.friction = 0
        //restitution == bounciness
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        
        //apply initial impulse to the ball so it`s starts moving around
        ball.physicsBody?.applyImpulse(CGVectorMake(2, -2))
        
        //create an paddle from image (CGRectGetMidX can be handy to get the midX position of the scene)
        let paddle = SKSpriteNode(imageNamed: paddleCatName)
        paddle.name = paddleCatName
        paddle.position = CGPointMake(self.frame.midX, paddle.size.height * 2)
        self.addChild(paddle)
        
        //adding some physics to the paddle so it can "communicate" with ball
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.frame.size)
        paddle.physicsBody?.friction = 0.4
        paddle.physicsBody?.restitution = 0.1
        paddle.physicsBody?.dynamic = false
        
        //create bottom collision
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        self.addChild(bottom)
        
        //adding bitmask to all nodes
        ball.physicsBody?.categoryBitMask = balBitmask
        paddle.physicsBody?.categoryBitMask = paddleBitmask
        bottom.physicsBody?.categoryBitMask = bottomBorderBitmask
        
        //add contact bitmask to determine when the ball hit border or brick
        ball.physicsBody?.contactTestBitMask = bottomBorderBitmask | brickBitmask
        
        //creating bricks
        let nrOfRows = 4
        let nrOfCols = 5
        let padding:CGFloat = 20
        var colWidth = SKSpriteNode(imageNamed: brickCatName).size.width
        //TODO find the way to write calculation below in on line
        var totalColWidth = (CGFloat(nrOfCols) * colWidth)
        var totalPaddingWidth = (CGFloat(nrOfCols - 1)) * padding
        var offsetX = (self.frame.size.width - (totalColWidth + CGFloat(totalPaddingWidth)))/2
        
        var offsetY: CGFloat = 100
        var nextColPos: CGFloat?
        for index in 1...nrOfRows {
            offsetY += 50
            nextColPos = 0
            for index in 1...nrOfCols {
//                let brick = SKSpriteNode(imageNamed: brickCatName)
                let brick : Brick = Brick(spriteNodeName: "normal", brickType: BrickType.NORMAL)
                brick.position = CGPointMake(offsetX + nextColPos!, offsetY)

                brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
                brick.physicsBody?.allowsRotation = false
                brick.physicsBody?.friction = 0
                //TODO replace name of the sprite node with brick category
                brick.name = brickCatName
                brick.physicsBody?.categoryBitMask = brickBitmask
                brick.physicsBody?.dynamic = false

                self.addChild(brick)
                
                nextColPos! += colWidth + padding
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("touch began")
        var touch = touches.anyObject() as UITouch
        var touchPos = touch.locationInNode(self)
        
        let body:SKPhysicsBody? = self.physicsWorld.bodyAtPoint(touchPos)
        
        if body?.node?.name == paddleCatName {
            println("paddle clicked")
            touchingTheScreen = true
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        if touchingTheScreen {
            let touch = touches.anyObject() as UITouch
            let touchPos = touch.locationInNode(self)
            let prevTouchLoc = touch.previousLocationInNode(self)
            
            let paddle = self.childNodeWithName(paddleCatName) as SKSpriteNode
            
            var newPosX = paddle.position.x + (touchPos.x - prevTouchLoc.x)
            newPosX = max(newPosX, paddle.size.width/2)
            newPosX = min(newPosX, self.size.width - paddle.size.width/2)
            
            paddle.position = CGPointMake(newPosX, paddle.position.y)
            
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == bottomBorderBitmask {
//            println("game over")
            if let mainView = view {
                let gameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene
                mainView.presentScene(gameOverScene)
            }
        }
        if contact.bodyA.categoryBitMask == brickBitmask {
//            println("brick hit")
            let brick = contact.bodyA.node! as? Brick
            
            if (brick!.onHit(game!.level!)){
                brick?.removeFromParent()
                game!.addPoints(brick!.brickType!.getPoints())
            }
        }
        
        println("Points: \(game!.getPoints())")
    }
    
    
}
