//
//  ViewController.swift
//  Asteroidz
//
//  Created by Luke Taylor on 22/05/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        if let scene = background(fileNamed:"background") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.size = skView.bounds.size
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
        
        setupElements()
        
    }
    
    func setupElements() {
        self.scoreButton.layer.cornerRadius = 2
        self.settingsButton.layer.cornerRadius = 2
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

