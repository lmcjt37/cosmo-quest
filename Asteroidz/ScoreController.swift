//
//  ScoreController.swift
//  Asteroidz
//
//  Created by Luke Taylor on 31/05/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import UIKit
import SpriteKit

class ScoreController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var fauxNavBar: UIView!
    
    let textCellIdentifier = "TextCell"
    let storedData = UserDefaults.standard.array(forKey: "scoreboard") as? [[String: AnyObject]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0)
        
        tableView.backgroundColor = UIColor.clear
        fauxNavBar.backgroundColor = UIColor(red: CGFloat(255/255), green: CGFloat(255/255), blue: CGFloat(255/255), alpha: CGFloat(0.3))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK:  UITableViewDelegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if storedData != nil {
            return storedData!.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let row = indexPath.row
        
        if storedData != nil {
            cell.textLabel?.text = storedData![row]["initials"] as? String
            cell.detailTextLabel?.text = storedData![row]["score"] as? String
        } else {
            cell.textLabel?.text = "No data found"
            cell.detailTextLabel?.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name:"Orbitron", size:20)
        cell.textLabel?.textColor = UIColor.white
        
        cell.detailTextLabel?.font = UIFont(name:"Orbitron", size:20)
        cell.detailTextLabel?.textColor = UIColor.white
            
        return cell
    }

}
