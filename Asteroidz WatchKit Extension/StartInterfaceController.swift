//
//  InterfaceController.swift
//  Asteroidz WatchKit Extension
//
//  Created by Luke Taylor on 04/04/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import Foundation
import WatchKit

class StartInterfaceController: WKInterfaceController {
    
//    var difficulty: Int!
//    var level: Int! = (StorageManager.storeManager.get(key: "difficulty") as? Int)!
    
    @IBOutlet var mainContainer: WKInterfaceGroup!
    @IBOutlet var asteroidBtn: WKInterfaceGroup!
    
    @IBAction func openGame() {
        let difficulty: Int!
        let level: Int = 0
        
        // needs fixing so that it comes from the StorageManager
        print(StorageManager.storeManager.get(key: "difficulty"))
        
        difficulty = Int(level) + 1
        pushController(withName: "Game", context: ["difficulty": difficulty])
    }
    
    @IBAction func openHelp() {
        presentController(withName: "Help", context: nil)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        becomeCurrentPage()
        
        mainContainer.setBackgroundImageNamed("ani-star-bg-vert")
        
        mainContainer.startAnimatingWithImages(in: NSRange(location: 0, length: 25), duration: 3.0, repeatCount: 0)
        
        asteroidBtn.setBackgroundImageNamed("asteroid")
        
        asteroidBtn.startAnimatingWithImages(in: NSRange(location: 0, length: 35), duration: 5.0, repeatCount: 0)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
}
