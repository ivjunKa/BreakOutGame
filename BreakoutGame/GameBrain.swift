//
//  GameBrain.swift
//  BreakoutGame
//
//  Created by Mad Max on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation

class GameBrain {
    var ballCount: Int {
        didSet {
            update()
        }
    }
    
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
        ballCount = 0
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
        if (ballCount == 0){
            finishGame("No more balls left!")
        }
    }
    
    func finishGame(message: String){
        //game finished
    }
}