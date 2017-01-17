//
//  GameOverInterfaceController.swift
//  Asteroidz
//
//  Created by Luke Taylor on 21/05/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import Foundation
import UIKit
import WatchKit

class GameOverInterfaceController: WKInterfaceController {
    
    var data: [String:AnyObject]?
    var hasEnded: Bool?
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var letterOne = "A"
    var letterTwo = "A"
    var letterThree = "A"
    
    @IBOutlet var background: WKInterfaceGroup!
    @IBOutlet var pickerOne: WKInterfacePicker!
    @IBOutlet var pickerTwo: WKInterfacePicker!
    @IBOutlet var pickerThree: WKInterfacePicker!
    
    @IBAction func homeButton() {
        if (hasEnded == true) {
            data!["initials"] = getName() as AnyObject?
            do {
                try WatchSessionManager.sharedManager.updateApplicationContext(applicationContext: data!)
            } catch {
                print("Oh snap! Couldn't update application context - Watch")
            }
        }
        dismiss()
    }
    
    @IBAction func pickerOneAction(_ value: Int) {
        letterOne = alphabet[value]
    }
    
    @IBAction func pickerTwoAction(_ value: Int) {
        letterTwo = alphabet[value]
    }
    
    @IBAction func pickerThreeAction(_ value: Int) {
        letterThree = alphabet[value]
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        data = context as? [String:AnyObject]
        hasEnded = data!["gameEnded"] as? Bool
        setupElements()
        
    }
    
    func getName() -> String {
        return "\(letterOne)\(letterTwo)\(letterThree)"
    }
    
    func setupElements() {
        self.setTitle("")
        
        self.background.setBackgroundImageNamed("ani-star-bg-vert")
        
        self.background.startAnimatingWithImages(in: NSRange(location: 0, length: 25), duration: 3.0, repeatCount: 0)
        
        if (hasEnded == true) {
            var pickerItems = [WKPickerItem]()
            
            for index in 0...25 {
                let pickerItem = WKPickerItem()
                pickerItem.title = alphabet[index]
                pickerItems.append(pickerItem)
            }
            pickerOne.setItems(pickerItems)
            pickerTwo.setItems(pickerItems)
            pickerThree.setItems(pickerItems)
        } else {
            pickerOne.setAlpha(0.0)
            pickerTwo.setAlpha(0.0)
            pickerThree.setAlpha(0.0)
        }
        
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
