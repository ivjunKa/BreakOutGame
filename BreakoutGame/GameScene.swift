//
//  GameScene.swift
//  BreakoutGame
//
//  Created by Home on 06/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import SpriteKit
import Accounts

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var game: GameBrain?
    var paddle: Paddle?
    var level: Level?
    
    var touchingTheScreen = false
    //Handling bonus countdown
    var bonusExpiresInSec: Float?
    var startCountDownBonus: Bool = false
    var getCurrentTime: Bool = false
    var bonusTypeAppliedNow: BonusType?
    //------
    var balCatName = "ball"
    var brickCatName = "brickwhite"
    var paddleCatName = "paddle"
    var bonusCatName = "bonus"

    var LABEL_POINTS = "POINTS"
    var LABEL_LIVES = "LIVES"
    var LABEL_POINTS_TEXT = "Points: "
    var LABEL_LIVES_TEXT = "Lives: "
    
    private final var PADDLE: String = "paddle_size";
    private final var BALLS: String = "starting_balls";
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var account: ACAccount?
    
    let balBitmask:UInt32 = 1
    let bottomBorderBitmask:UInt32 = 2
    let brickBitmask:UInt32 = 3
    let paddleBitmask:UInt32 = 4
    let bonusBitmask:UInt32 = 5
    
    let fadeoutAction = SKAction.customActionWithDuration(10.0, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
//        node.texture = SKTexture(imageNamed: "brickwhite_broken")
//        let spriteNode = node as SKSpriteNode
        node.removeFromParent()
    })
    override init(size: CGSize){
        super.init(size: size)
        
        self.level = Level(levelName: "1-2",gameBounds: self.frame.size)
        game = GameBrain(level: level!, gameBounds: self.frame.size)
        //adding delegate to detect collision
        self.physicsWorld.contactDelegate = self
        //creating and adding backround image
//        let backgroundImage = SKSpriteNode(imageNamed: "bgwall")
        let backgroundImage = level?.getBackground()
        
        backgroundImage!.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(backgroundImage!)
        
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
        
        //load labels
        loadLabels()
        
        //load bricks
        
        loadBricks()
        
        //creating an ball from image
        addBalls()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch = touches.anyObject() as UITouch
        var touchPos = touch.locationInNode(self)
        
        let body:SKPhysicsBody? = self.physicsWorld.bodyAtPoint(touchPos)
        touchingTheScreen = true
        
        if body?.node?.name == paddleCatName {
            println("paddle clicked")
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        if touchingTheScreen {
            let touch = touches.anyObject() as UITouch
            let touchPos = touch.locationInNode(self)
            let prevTouchLoc = touch.previousLocationInNode(self)
            
            var newPosX = paddle!.position.x + (touchPos.x - prevTouchLoc.x)
            newPosX = max(newPosX, paddle!.size.width/2)
            newPosX = min(newPosX, self.size.width - paddle!.size.width/2)
            
            paddle!.position = CGPointMake(newPosX, paddle!.position.y)
            paddle!.paddleMove()
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        paddle!.shoot()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == bottomBorderBitmask {
            //something hits the bottom
            if let ball = contact.bodyB.node as? Ball {
                if !ball.dead {
                    //we lost a ball
                    ball.dead = true
                    game!.ballLost(ball)
                    contact.bodyB.node?.removeFromParent()
                    contact.bodyB.categoryBitMask = 99
                }
            } else if let bonus = contact.bodyB.node as? Bonus {
                //we lost a bonus
                contact.bodyB.node?.removeFromParent()
                contact.bodyB.categoryBitMask = 99
            }
        } else if contact.bodyB.categoryBitMask == balBitmask && contact.bodyA.categoryBitMask == brickBitmask {
            //WE HIT A BRICK HURAY
            let brick = contact.bodyA.node! as Brick
            brick.texture = SKTexture(imageNamed: "brickred")
            if game!.onBrickHit(brick) {
                //returns true when the brick breaks
                if brick.brickType! == BrickType.BONUS{
                    brick.texture = SKTexture(imageNamed: "brickred_broken")
                }
                else if brick.brickType! == BrickType.NORMAL {
                    brick.texture = SKTexture(imageNamed: "brickwhite_broken")
                }
                brick.physicsBody?.collisionBitMask = 0
                brick.runAction(SKAction.fadeOutWithDuration(0.1), completion : {
                brick.removeFromParent()
                    if let bonus = brick.bonus {
                        println("trying to create an bonus")
                        bonus.position = CGPointMake(brick.position.x, brick.position.y)
                        bonus.physicsBody = SKPhysicsBody(circleOfRadius: bonus.frame.size.width/2)
                        bonus.physicsBody?.allowsRotation = false
                        bonus.name = self.bonusCatName
                        bonus.physicsBody?.categoryBitMask = self.bonusBitmask
//                        bonus.physicsBody?.contactTestBitMask = self.bottomBorderBitmask | self.paddleBitmask
                        bonus.physicsBody?.contactTestBitMask = self.balBitmask
//                        bonus.physicsBody?.collisionBitMask = 0
                        bonus.physicsBody?.dynamic = false
                        println("TRYING TO ADD AN BONUS")
                        if bonus.parent == nil {
                            self.addChild(bonus)
                        }
//                        bonus.physicsBody?.applyImpulse(CGVectorMake(0, -3))
                    }
                })
                if checkWin(){
                    let gameOverScene = GameOverScene(size: self.size, playerWin : true)
                    self.view?.presentScene(gameOverScene)
                }
            }
        }
        //bonus contact handler
        if contact.bodyB.categoryBitMask == bonusBitmask && contact.bodyA.categoryBitMask == paddleBitmask {
            if let bonus = contact.bodyB.node as? Bonus {
                bonus.bType?.applyBonus(self)
                bonusTypeAppliedNow = bonus.bType?
            }
            contact.bodyB.node?.removeFromParent()
        }
        if contact.bodyA.categoryBitMask == bonusBitmask && contact.bodyB.categoryBitMask == balBitmask{
            if let bonus = contact.bodyA.node as? Bonus {
                bonus.bType?.applyBonus(self)
                bonusTypeAppliedNow = bonus.bType?
            }
            contact.bodyA.node?.removeFromParent()
        }

        if checkGameForUpdate(){
            checkGameForNewSceneNodes()
        }
    }
    
    func checkGameForUpdate() -> Bool {
        if checkWin(){
            gameOver(true)
        } else if checkLoss() {
            gameOver(false)
        } else {
            updateLabels()
            return true
        }
        return false
    }
    
    func updateLabels(){
        getLabel(LABEL_POINTS)?.text = LABEL_POINTS_TEXT + "\(game!.getPoints())"
        getLabel(LABEL_LIVES)?.text = LABEL_LIVES_TEXT + "\(game!.livesCount)"
    }
    
    func getLabel(tag: String) -> SKLabelNode? {
        for nodes in self.children {
            if let node = nodes as? SKLabelNode {
                if node.name == tag {
                    return node
                }
            }
        }
        return nil
    }
    
    func checkGameForNewSceneNodes(){
        while game!.ballsToAdd > 0 {
            addBall()
        }
    }
    
    func addBalls(){
        if defaults.objectForKey(BALLS) != nil {
            for i in 1...defaults.integerForKey(BALLS) {
                addBall()
            }
        } else {addBall()}
    }
    
    func addBall(){
        var ball = Ball(imageNamed: balCatName)
        ball.name = balCatName
        ball.position = paddle!.position
        ball.position.y += paddle!.frame.size.height*2
        //creating the physics body for the ball so it can "communicate" with the world
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        ball.physicsBody?.friction = 0
        //restitution == bounciness
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.allowsRotation = false
        
        ball.physicsBody?.categoryBitMask = balBitmask
//        ball.physicsBody?.collisionBitMask = 0
        
        //add contact bitmask to determine when the ball hit border or brick
        ball.physicsBody?.contactTestBitMask = bottomBorderBitmask | brickBitmask
        
        self.addChild(ball)
        paddle!.addBall(ball)
        game!.onAddBallToPaddle(ball)
    }
    
    func createPaddle(){
        paddle = Paddle(spriteName: paddleCatName)
        if defaults.objectForKey(PADDLE) != nil {
            paddle!.xScale = CGFloat(Float(defaults.integerForKey(PADDLE)) / 5)
        }
    
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
        var bricks = level?.getBricksStructure()
        for brick in bricks! {
            self.addChild(brick)
        }
    }
    
    func loadLabels(){
        let labelDistance: CGFloat = 20
        var label = addLabel(LABEL_POINTS,point: CGPointMake(0, self.frame.maxY-labelDistance))
        addLabel(LABEL_LIVES, point: CGPointMake(0, label.position.y-labelDistance))
        addLabel("BLA", point: CGPointMake(self.frame.midX, self.frame.midY))
        updateLabels()
    }
    
    func addLabel(tag: String, point: CGPoint) -> SKLabelNode{
        let message = SKLabelNode(fontNamed: "Arial")
        message.name = tag
        message.fontSize = 15
        message.position = point
        message.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.addChild(message)
        return message
    }
    func dismissLabel(tag:String){
        for nodes in self.children {
            let node = nodes as SKNode
            if node.name == tag {
                node.removeFromParent()
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
        gameOverScene.account = account
        self.view?.presentScene(gameOverScene)
    }
    override func update(currentTime: NSTimeInterval) {
        if getCurrentTime {
            self.bonusExpiresInSec = Float(currentTime) + game!.countDownBonus
            getCurrentTime = false
        }
        if startCountDownBonus {
            if Float(currentTime) >= self.bonusExpiresInSec {
                bonusTypeAppliedNow?.dismissBonus(self)
                startCountDownBonus = false
            }
        }
    }
}
