//
//  StorageManager.swift
//  Asteroidz
//
//  Created by Luke Taylor on 02/08/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import Foundation

class StorageManager: NSObject {
    
    static let storeManager = StorageManager()
    fileprivate override init() {
        super.init()
    }
    
    fileprivate let defaults = UserDefaults.standard
    
}

// MARK: Extend storage manager
extension StorageManager {
    
    func set(context: [String:AnyObject]) {
        // grab difficulty from passed context (applicationContext)
        if let difficulty = context["difficulty"] as? Int {
            defaults.set(difficulty, forKey: "difficulty")
        }
        defaults.synchronize()
    }
    
    func get(key: String) -> AnyObject {
        if let _ = defaults.object(forKey: key) {
            return defaults.object(forKey: key)! as AnyObject
        }
        return false as AnyObject
    }
    
}
