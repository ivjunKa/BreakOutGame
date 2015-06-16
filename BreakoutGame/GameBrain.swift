//
//  GameBrain.swift
//  BreakoutGame
//
//  Created by Mad Max on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation

class GameBrain {
    var livesCount: Int {
        didSet {
            update()
        }
    }
    
    var ballCount: Int = 1
    var ballsToAdd: Int = 0
    var finished: Bool = false
    
    var points: Int {
        didSet {
            update()
        }
    }
    
    var level: Level?
    
    convenience init(){
        self.init(level: Level(levelName: "1-1"))
    }
    
    init(level l: Level){
        livesCount = 1
        points = 0
        self.level = l
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
                shouldAddBallToPaddle()
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
        ballsToAdd--
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