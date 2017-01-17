//
//  background.swift
//  Asteroidz
//
//  Created by Luke Taylor on 20/06/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import SpriteKit

class background: SKScene {

    let image = SKSpriteNode(imageNamed: "ios-star-bg")
    
    override func didMove(to view: SKView) {
        
        image.anchorPoint = CGPoint.zero
        image.position = CGPoint.zero
        image.zPosition = 0
        self.addChild(image)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        image.position = CGPoint(x: image.position.x, y: image.position.y - 2)
        
        if (image.position.y < -image.size.height/2) {
            image.position = CGPoint.zero
        }
        
    }

}
