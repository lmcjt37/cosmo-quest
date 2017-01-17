//
//  GameInterfaceController.swift
//  Asteroidz
//
//  Created by Luke Taylor on 27/04/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import Foundation
import UIKit
import WatchKit

class GameInterfaceController: WKInterfaceController {
    
    var count = 5
    var numberOfAsteroids = 5
    var isAnimating: Bool = false
    var dice: Int = 0
    var distance: Float = 122.0
    var currentPosition: Int = 0
    var currentScore: Int = 0
    var waves: Int = 0
    var level: Int = 1
    var asteroidNumber: Int = 1
    var hasFinished: Bool = true
    var difficulty: Int!
    
    var countdownTimer: Timer = Timer()
    var asteroidTimer: Timer = Timer()
    var completionTimer: Timer = Timer()
    var finishGameTimer: Timer = Timer()
    
    var speed: TimeInterval = TimeInterval(1.5)
    
    @IBOutlet var countdownLabel: WKInterfaceLabel!
    @IBOutlet var ship: WKInterfaceGroup!
    @IBOutlet var picker: WKInterfacePicker!
    @IBOutlet var background: WKInterfaceGroup!
    
    @IBOutlet var asteroidGroup: WKInterfaceGroup!
    @IBOutlet var asteroid1: WKInterfaceGroup!
    @IBOutlet var asteroid2: WKInterfaceGroup!
    @IBOutlet var asteroid3: WKInterfaceGroup!
    @IBOutlet var asteroid4: WKInterfaceGroup!
    @IBOutlet var asteroid5: WKInterfaceGroup!
    
    var asteroids: [WKInterfaceGroup] { return [asteroid1, asteroid2, asteroid3, asteroid4, asteroid5] }
    
    @IBAction func pickerAction(_ value: Int) {
        currentPosition = value
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let currentDevice = WKInterfaceDevice.current()
        let bounds = currentDevice.screenBounds
        let is48Watch = (bounds.height > 170.0)
        // size: (x, y, width, height)
        // 38mm: (0.0, 0.0, 136.0, 170.0)
        // 42mm: (0.0, 0.0, 156.0, 195.0)
        
        if (!is48Watch) {
            distance = 105.0
            ship.setHeight(CGFloat(40))
        }
        
        let data = context as? [String:AnyObject]
        difficulty = (data!["difficulty"] as? Int)!
        
        switch difficulty {
        case 2:
            speed = speed - 0.4
            break;
        case 3:
            speed = speed - 0.8
            break;
        default:
            speed = 1.5
            break;
        }
        
        background.setBackgroundImageNamed("ani-star-bg-vert")
        background.startAnimatingWithImages(in: NSRange(location: 0, length: 25), duration: 1.5, repeatCount: 0)
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(GameInterfaceController.initialise), userInfo: nil, repeats: true)
        
        var pickerItems = [WKPickerItem]()
        
        for index in 0...4 {
            let pickerItem = WKPickerItem()
            pickerItem.contentImage = WKImage(imageName: "percent\(index)")
            pickerItems.append(pickerItem)
        }
        picker.setItems(pickerItems)
        
        var imageArray = [UIImage]()
        
        for index in 0...4 {
            let image = UIImage(named: "ship\(index)")
            imageArray.append(image!)
        }
        
        let progressImages = UIImage.animatedImage(with: imageArray,
            duration: 0.0)
        ship.setBackgroundImage(progressImages)
        picker.setCoordinatedAnimations([ship])
        
    }
    
    func initialise() {
        if(count > 0) {
            count -= 1
            if (count > 1) {
                animateText("\(count - 1)")
            } else if (count == 1) {
                animateText("Start!")
            }
        } else {
            countdownLabel.setHidden(true)
            countdownTimer.invalidate()
            ship.setAlpha(1.0)
            setupAsteroids()
            startAnimating()
            
        }
    }
    
    func animateText(_ text: String) {
        
        self.animate(withDuration: 0.6, animations: {
            self.countdownLabel.setAlpha(0.0)
        })
        countdownLabel.setText(text)
        countdownLabel.setAlpha(1)
        
    }
    
    func startAnimating() {
        
        if (!isAnimating) {
            
            setAsteroidPosition()
            startAsteroids()
            asteroidTimer = Timer.scheduledTimer(timeInterval: speed + 0.2, target: self, selector: #selector(GameInterfaceController.startAsteroids), userInfo: nil, repeats: true)
        }
    }
    
    func finishGame() {
        cleanUp()
        presentController(withName: "Game Over", context: ["score": String(currentScore), "gameEnded": hasFinished])
        pop()
    }
    
    func collisionDetection() {
        if (dice == currentPosition) {
            ship.setBackgroundImageNamed("explosion_\(currentPosition + 1)_")
            ship.startAnimatingWithImages(in: NSRange(location: 0, length: 7), duration: 1.2, repeatCount: 1)
            finishGameTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(GameInterfaceController.finishGame), userInfo:nil, repeats: true)
            
        } else {
            currentScore = currentScore + (1 * difficulty)
            self.setTitle("Score: \(currentScore)")
            setAsteroidSpeed()
        }
    }
    
    func completion() {
        
        collisionDetection()
        
        asteroidGroup.setAlpha(0.0)
        asteroidGroup.setHeight(30)
        asteroids[dice].setAlpha(0.0)
        completionTimer.invalidate()
        
        setAsteroidPosition()
        
        if (!isAnimating) {
            isAnimating = true
        }
    }
    
    func setupAsteroids() {
        let idx = numberOfAsteroids - 1
        for index in 0...idx {
            asteroids[index].setBackgroundImageNamed("asteroid")
            asteroids[index].setAlpha(0.0)
        }
    }
    
    func startAsteroids() {
        
        asteroids[dice].setAlpha(1.0)
        asteroids[dice].startAnimatingWithImages(in: NSRange(location: 0, length: 35), duration: 1.5, repeatCount: 0)
        
        self.animate(withDuration: 0.3, animations: {
            self.asteroidGroup.setAlpha(1.0)
        })
        
        self.animate(withDuration: speed, animations: {
            self.asteroidGroup.setHeight(CGFloat(self.distance))
        })
        
        // hack for watchkit as animateWithDuration
        // doesn't seem to support completion argument
        completionTimer = Timer.scheduledTimer(timeInterval: speed - 0.1, target: self, selector: #selector(GameInterfaceController.completion), userInfo: nil, repeats: false)
        
    }
    
    func setAsteroidSpeed() {
        waves += 1
        if waves > 4 {
            level += 1
            waves = 0
            speed = speed - 0.1
        }
    }
    
    // TODO: incorporate an increase in asteroids
    func setNumberOfAsteroids() {
        if level > 8 {
            level = 0
            asteroidNumber += asteroidNumber
        }
    }
    
    func rng(_ num: Int) -> Int {
        return Int(arc4random_uniform(UInt32(num)))
    }
    
    func setAsteroidPosition() {
        var num = rng(numberOfAsteroids)
        if (num == dice) {
            num = rng(numberOfAsteroids)
        }
        dice = num
    }
    
    func cleanUp() {
        // cleanup timers to avoid errors with persistence
        let idx = numberOfAsteroids - 1
        for index in 0...idx {
            asteroids[index].setAlpha(0.0)
        }
        self.asteroidGroup.setHeight(30)
        
        asteroidTimer.invalidate()
        completionTimer.invalidate()
        finishGameTimer.invalidate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        hasFinished = false
        finishGame()
    }
    
    
}
