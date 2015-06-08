//
//  Level.swift
//  BreakoutGame
//
//  Created by Mad Max on 08/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import Foundation

class Level {
    
    var levelName: String?
    
    init(levelName name: String){
        self.levelName = name
    }
    
    func getLevelName() -> String {
        return levelName!
    }
}