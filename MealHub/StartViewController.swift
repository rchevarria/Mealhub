//
//  GettingStartedViewController.swift
//  DessertsHub
//
//  Created by Ryan Chevarria on 9/21/23.
//

import UIKit

class StartViewController: UIViewController {
    
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        performSegue(withIdentifier: "GetStartedToDessertsSegue", sender: self)
    }
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 10
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.black.cgColor
    }
    
}
