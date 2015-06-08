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
    
    var level: Level?
    
    init(){
        ballCount = 0
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