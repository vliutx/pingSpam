//
//  SignUpViewController.swift
//  NSW23Recorder
//
//  Created by Vincent Liu on 2/29/20.
//  Copyright © 2020 UT BME Team 15. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField1: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupElements()
    }

    func setupElements() {
        errorLabel.alpha = 0
        // There was supposed to be more stuff lol
    }
    
    func validateFields() -> String? {
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordField1.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField2.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        let cleanedEmail = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !FormValidation.isEmailValid(cleanedEmail) {
            return "Invalid E-mail."
        }
        
        let cleanedPassword1 = passwordField1.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !FormValidation.isPasswordValid(cleanedPassword1) {
            return "Please make sure your password is at least 8 characters and contains a special character and a number."
        }
        
        let cleanedPassword2 = passwordField2.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedPassword1 != cleanedPassword2 {
            return "Passwords must match."
        }
        
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        self.view.endEditing(true)
        let error = validateFields()
        if error != nil {
            // Something wrong with the form
            showError(error!)
        } else {
            // Everything's gucci, make the user
            let name = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField1.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError("Error creating user.")
                } else {
                    // User created successfully
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["Name":name, "uid":result!.user.uid], completion: { (error) in
                        if error != nil {
                            self.showError("Could not save name lmao")
                        }
                    })
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let recorderController = storyboard?.instantiateViewController(withIdentifier: "RecorderVC")
        
        view.window?.rootViewController = recorderController
        view.window?.makeKeyAndVisible()
    }
    
    
}
