//
//  SettingsViewController.swift
//  BreakoutGame
//
//  Created by Mad Max on 17/06/15.
//  Copyright (c) 2015 nl.han.ica.mad. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private final var LIVES: String = "startlives";
    private final var PADDLE: String = "paddle_size";
    private final var BALLS: String = "starting_balls";
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var startingBalls: UISegmentedControl!
    @IBOutlet weak var paddleStepper: UIStepper!
    @IBOutlet weak var livesSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (defaults.objectForKey(LIVES) != nil) {
            livesSlider.value = Float(defaults.integerForKey(LIVES))
            livesLabel.text = "lives: \(defaults.integerForKey(LIVES))"
        }
        if (defaults.objectForKey(PADDLE) != nil) {
            paddleStepper.value = Double(defaults.integerForKey(PADDLE))
            paddleSizeLabel.text = "paddle size: \(defaults.integerForKey(PADDLE))"
        }
        if (defaults.objectForKey(BALLS) != nil) {
            startingBalls.selectedSegmentIndex = defaults.integerForKey(BALLS)-1
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBOutlet weak var livesLabel: UILabel!
    @IBAction func numLives(sender: UISlider) {
        livesLabel.text = "lives: \(Int(sender.value))"
        defaults.setInteger(Int(sender.value), forKey: LIVES)
    }
    
    @IBAction func startingBalls(sender: UISegmentedControl) {
        println("arg: \(sender.selectedSegmentIndex)")
        defaults.setInteger(sender.selectedSegmentIndex+1, forKey: BALLS)
    }
    
    @IBOutlet weak var paddleSizeLabel: UILabel!
    @IBAction func paddleSizeStepper(sender: UIStepper) {
        paddleSizeLabel.text = "paddle size: \(Int(sender.value))"
        defaults.setInteger(Int(sender.value), forKey: PADDLE)
    }
}