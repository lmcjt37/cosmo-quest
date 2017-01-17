//
//  AboutController.swift
//  Asteroidz
//
//  Created by Luke Taylor on 26/07/2016.
//  Copyright © 2016 Luke Taylor. All rights reserved.
//

import UIKit

protocol SegueDelegate: class {
    func showPageElements()
}

class AboutController: UIViewController {
    
    var delegate: SegueDelegate? = nil

    @IBAction func dismissAction(_ sender: AnyObject) {
        delegate?.showPageElements()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
