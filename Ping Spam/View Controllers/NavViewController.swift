//
//  NavViewController.swift
//  NSW23Recorder
//
//  Created by Vincent Liu on 5/4/20.
//  Copyright © 2020 UT BME Team 15. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class NavViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //I really made this controller just for logging out lmao
    @IBAction func LogoutButtonPress(_ sender: Any) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! UINavigationController
            self.present(vc, animated: false, completion: nil)
        }
    }

}
