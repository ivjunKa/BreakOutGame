//
//  Paddle.swift
//  BreakoutGame
//
//  Created by Mad Max on 16/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation

import SpriteKit

class Paddle : SKSpriteNode {

    private var linkedBalls: [Ball] = []
    
    init(spriteName: String){
        let texture = SKTexture(imageNamed: spriteName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    func addBall(ball: Ball){
        linkedBalls.append(ball)
        paddleMove()
    }
    
    func shoot(touch: UITouch){
        if !linkedBalls.isEmpty {
            let vector = CGVectorMake(2,-2)
            
            for ball in linkedBalls {
                ball.physicsBody?.applyImpulse(vector)
            }
            linkedBalls.removeAll(keepCapacity: false)
        }
    }
    
    func paddleMove() {
        let position = CGPoint(x: self.position.x, y: self.position.y+self.frame.height)
        if !linkedBalls.isEmpty {
            for ball in linkedBalls {
                ball.position = position
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
