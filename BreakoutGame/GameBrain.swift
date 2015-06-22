//
//  GameBrain.swift
//  BreakoutGame
//
//  Created by Mad Max on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation
import SpriteKit
class GameBrain {
    var livesCount: Int = 1
    var ballCount: Int = 0
    var ballsToAdd: Int = 0
    var finished: Bool = false
    var points: Int = 0
    var countDownBonus: Float = 0.0
    var gameBounds: CGSize?
    var level: Level?
    
    private final var LIVES: String = "startlives";
    private final var BALLS: String = "starting_balls";
    let defaults = NSUserDefaults.standardUserDefaults()
    
    init(level l: Level, gameBounds: CGSize){
        self.level = l
        self.gameBounds = gameBounds
        
        if (defaults.objectForKey(LIVES) != nil) {
            livesCount = defaults.integerForKey(LIVES)
        }
    }
    
    func addPoints(p: Int){
        points += p
    }
    
    func getPoints() -> Int {
        return points
    }
    
    func update(){
        if ballCount == 0{
            if livesCount > 0 {
                livesCount--
                if (defaults.objectForKey(BALLS) != nil) {
                    for i in 1...defaults.integerForKey(BALLS){
                        shouldAddBallToPaddle()
                    }
                } else {shouldAddBallToPaddle()}
            } else {
                //game over
                finishGame("No lives left")
            }
        }
    }
    
    func ballLost(ball: Ball){
        ballCount--
        update()
    }
    
    func getBallsToAdd() -> Int {
        return ballsToAdd
    }
    
    func shouldAddBallToPaddle (){
        ballsToAdd++
    }
    
    func onAddBallToPaddle(ball: Ball) {
        ballCount++
        if ballsToAdd > 0 {
            ballsToAdd--
        }
    }
    
    func onBrickHit(brick: Brick) -> Bool {
        let broken = brick.onHit(self)
        if broken {
            addPoints(brick.getPoints())
        }
        
        return broken
    }
    
    func finishGame(message: String){
        finished = true
        println(message)
    }
}