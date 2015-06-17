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
    
    var levelName: String?
    var nrOfRows:Int?
    var nrOfCols:Int?
    var padding:CGFloat?
    var colWidth:CGFloat?
    
    class brickPositions {
        var brickCoords: CGPoint?
        var brickTypeName: String?
        var brickImg: String?
        init(brickCoords: Int, brickTypeName: String, brickImg: String){
            
        }
    }
    init(levelName name: String){
        self.levelName = name
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
            
            
        default: println("1-1")
        }
    }
}