//
//  GameViewController.swift
//  BreakoutGame
//
//  Created by Home on 06/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let spriteKitView = self.view as SKView
        
        if spriteKitView.scene == nil {
            
            spriteKitView.showsFPS = true
            spriteKitView.showsNodeCount = true
            let gameScene = GameScene(size: spriteKitView.bounds.size)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            spriteKitView.presentScene(gameScene)
        }

    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
