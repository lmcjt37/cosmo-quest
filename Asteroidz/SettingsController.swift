//
//  SettingsController.swift
//  Asteroidz
//
//  Created by Luke Taylor on 31/05/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import MessageUI
import SpriteKit
import UIKit
import WatchKit

class SettingsController: UIViewController, MFMailComposeViewControllerDelegate, SegueDelegate {
    
    @IBOutlet weak var fauxNavBar: UIView!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var lineBreakView: UIView!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var bugButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    var difficulty: Int = 0
    var currentDifficulty: Int = 0
    var defaults = UserDefaults.standard
    
    @IBAction func difficultyAction(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 1:
            // medium
            difficulty = 1
            break;
        case 2:
            // hard
            difficulty = 2
            break;
        default:
            // easy
            difficulty = 0
            break; 
        }
        
        let difficultyOptionDialog = UIAlertController(title: "Change difficulty", message: "Are you sure you want to change the difficulty?", preferredStyle: UIAlertControllerStyle.alert)
        
        difficultyOptionDialog.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.currentDifficulty = self.difficulty
            self.defaults.set(self.difficulty, forKey: "difficulty")
            do {
                try WatchSessionManager.sharedManager.updateApplicationContext(["difficulty": self.difficulty as AnyObject])
            } catch {
                print("Oh snap! Couldn't update application context - App")
            }
        }))
        
        difficultyOptionDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.segmentedControl.selectedSegmentIndex = self.currentDifficulty
        }))
        
        present(difficultyOptionDialog, animated: true, completion: nil)
    }
    
    @IBAction func resetAction(_ sender: AnyObject) {        
        let optionDialog = UIAlertController(title: "Reset data", message: "Please be aware, this will erase all current scoreboard data.", preferredStyle: UIAlertControllerStyle.alert)
        
        optionDialog.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.defaults.set(nil, forKey: "scoreboard")
        }))
        
        optionDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(optionDialog, animated: true, completion: nil)
    }
    
    @IBAction func feedbackAction(_ sender: AnyObject) {
        jumpToAppStore("com.luketaylor.asteroidz")
    }
    
    @IBAction func bugAction(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        mailComposeViewController.modalPresentationStyle = .overCurrentContext
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
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

        fauxNavBar.backgroundColor = UIColor(red: CGFloat(255/255), green: CGFloat(255/255), blue: CGFloat(255/255), alpha: CGFloat(0.3))
        
        self.segmentedControl.layer.cornerRadius = 2

        if let storedData = defaults.object(forKey: "difficulty") {
            self.segmentedControl.selectedSegmentIndex = (storedData as? Int)!
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["help@lmcjt.com"])
        mailComposerVC.setSubject("Asteroidz - bug report")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "Could Not Send Email", message:
            "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func jumpToAppStore(_ appId: String) {
        let url = "itms-apps://itunes.apple.com/app/id\(appId)"
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    func hidePageElements() {
        self.navigationController?.isNavigationBarHidden = true
        fauxNavBar.alpha = 0
        difficultyLabel.alpha = 0
        segmentedControl.alpha = 0
        resetButton.alpha = 0
        lineBreakView.alpha = 0
        feedbackButton.alpha = 0
        bugButton.alpha = 0
        aboutButton.alpha = 0
    }
    
    func showPageElements() {
        self.navigationController?.isNavigationBarHidden = false
        fauxNavBar.alpha = 1
        difficultyLabel.alpha = 1
        segmentedControl.alpha = 1
        resetButton.alpha = 1
        lineBreakView.alpha = 1
        feedbackButton.alpha = 1
        bugButton.alpha = 1
        aboutButton.alpha = 1
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hidePageElements()
        let aboutVC = segue.destination as! AboutController
        aboutVC.delegate = self
    }
    
}
