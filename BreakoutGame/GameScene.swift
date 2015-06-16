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
    var paddle: Paddle?
    
    var touchingTheScreen = false
    
    var balCatName = "ball"
    var brickCatName = "brickwhite"
    var paddleCatName = "paddle"

    var bonusCatName = "bonus"

    let balBitmask:UInt32 = 1
    let bottomBorderBitmask:UInt32 = 2
    let brickBitmask:UInt32 = 3
    let paddleBitmask:UInt32 = 4
    let bonusBitmask:UInt32 = 5
    
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
        
        //create bottom collision
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        self.addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomBorderBitmask
        
        //create an paddle from image (CGRectGetMidX can be handy to get the midX position of the scene)
        createPaddle()
        
        loadBricks()
        
        //creating an ball from image
        addBall()
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
            if let ball = contact.bodyB.node as? Ball {
                game!.ballLost(ball)
                ball.removeFromParent()
            } else if let bonus = contact.bodyB.node as? Bonus {
                println("BONUS HITS BOTTOM")
                
            }
        }

        if contact.bodyB.categoryBitMask == balBitmask && contact.bodyA.categoryBitMask == brickBitmask {
            //WE HIT A BRICK
            let brick = contact.bodyA.node! as Brick
            if game!.onBrickHit(brick) {
                brick.removeFromParent()

                if let bonus = brick.bonus {
                    bonus.position = CGPointMake(brick.position.x, brick.position.y)
                    bonus.physicsBody = SKPhysicsBody(rectangleOfSize: bonus.frame.size)
                    bonus.physicsBody?.allowsRotation = false
                    bonus.name = bonusCatName
                    bonus.physicsBody?.categoryBitMask = bonusBitmask
                    bonus.physicsBody?.contactTestBitMask = bottomBorderBitmask | paddleBitmask
                    self.addChild(bonus)
                    bonus.physicsBody?.applyImpulse(CGVectorMake(2, -2))
                }
                if checkWin(){
                    let gameOverScene = GameOverScene(size: self.size, playerWin : true)
                    self.view?.presentScene(gameOverScene)
                }
            }
        }
        if contact.bodyB.categoryBitMask == bonusBitmask {
            println("bonus is now colliding")
        }
        
        if checkGameForUpdate() {
            checkGameForNewSceneNodes()
        }
        println("Points: \(game!.getPoints())")
    }
    
    func checkGameForUpdate() -> Bool {
        if checkWin(){
            gameOver(true)
        } else if checkLoss() {
            gameOver(false)
        } else {
            return true
        }
        return false
    }
    
    func checkGameForNewSceneNodes(){
        while game!.ballsToAdd > 0 {
            addBall()
        }
    }
    
    func addBall(){
        var ball = Ball(imageNamed: balCatName)
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
        
        ball.physicsBody?.categoryBitMask = balBitmask
        
        //add contact bitmask to determine when the ball hit border or brick
        ball.physicsBody?.contactTestBitMask = bottomBorderBitmask | brickBitmask
        
        //apply initial impulse to the ball so it`s starts moving around
        
        game!.onAddBallToPaddle(ball)
    }
    
    func createPaddle(){
        paddle = Paddle(spriteName: paddleCatName)
        paddle!.name = paddleCatName
        paddle!.position = CGPointMake(self.frame.midX, paddle!.size.height * 2)
        self.addChild(paddle!)
        
        //adding some physics to the paddle so it can "communicate" with ball
        paddle!.physicsBody = SKPhysicsBody(rectangleOfSize: paddle!.frame.size)
        paddle!.physicsBody?.friction = 0.4
        paddle!.physicsBody?.restitution = 0.1
        paddle!.physicsBody?.dynamic = false
        
        //adding bitmask to all nodes
        paddle!.physicsBody?.categoryBitMask = paddleBitmask
    }
    
    func loadBricks(){
        //creating bricks
        let nrOfRows = 3
        let nrOfCols = 3
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
                let brick : Brick = Brick(spriteNodeName: "normal", brickType: index == 1 ? BrickType.BONUS : BrickType.NORMAL,bonusAdded: index%2 == 0 ? true : false)
                brick.position = CGPointMake(offsetX + nextColPos!, offsetY)
                
                brick.physicsBody = SKPhysicsBody(rectangleOfSize: brick.frame.size)
                brick.physicsBody?.allowsRotation = false
                brick.physicsBody?.friction = 0
                //TODO replace name of the sprite node with brick category
                brick.name = brickCatName
                brick.physicsBody?.categoryBitMask = brickBitmask
                //                brick.physicsBody?.contactTestBitMask = balBitmask
                brick.physicsBody?.dynamic = false
                
                self.addChild(brick)
                
                nextColPos! += colWidth + padding
            }
        }
    }
    
    func checkWin() -> Bool{
        var totalBricks = 0
        for nodes in self.children {
            let node = nodes as SKNode
            if node.name == brickCatName {
                totalBricks += 1
            }
        }
        return totalBricks == 0
    }
    
    func checkLoss() -> Bool {
        return game!.finished
    }
    
    func gameOver(win: Bool) {
        let gameOverScene = GameOverScene(size: self.size, playerWin : win)
        self.view?.presentScene(gameOverScene)
    }
    
}
