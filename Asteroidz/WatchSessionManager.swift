//
//  WatchSessionManager.swift
//  Asteroidz
//
//  Created by Luke Taylor on 31/07/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import WatchConnectivity
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class WatchSessionManager: NSObject, WCSessionDelegate {
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        // code
    }

    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        // code
    }

    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // code
    }

    
    static let sharedManager = WatchSessionManager()
    fileprivate override init() {
        super.init()
    }
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    
    fileprivate var validSession: WCSession? {
        
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
}

// MARK: Application Context
extension WatchSessionManager {
    
    // Sender
    func updateApplicationContext(_ applicationContext: [String : AnyObject]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
    
    // Receiver
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        // handle receiving application context
        
        DispatchQueue.main.async {
            
            let defaults = UserDefaults.standard
            var scoreboardObject: [Dictionary<String, AnyObject>] = []
            
            scoreboardObject.append(applicationContext as [String : AnyObject])
            
            if let storedData = defaults.array(forKey: "scoreboard") as? [[String: AnyObject]] {
                for item in storedData {
                    scoreboardObject.append(item)
                }
            }
            
            scoreboardObject.sort {
                item1, item2 in
                let sortItem1 = Int(item1["score"] as! String)
                let sortItem2 = Int(item2["score"] as! String)
                return sortItem1 > sortItem2
            }
            
            if scoreboardObject.count > 10 {
                scoreboardObject.removeLast()
            }
            
            defaults.set(scoreboardObject, forKey: "scoreboard")
            defaults.synchronize()
            
        }
    }
}
