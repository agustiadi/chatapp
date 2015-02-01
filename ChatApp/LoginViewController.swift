//
//  ViewController.swift
//  ChatApp
//
//  Created by Agustiadi on 31/1/15.
//  Copyright (c) 2015 Agustiadi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var signupActive = false
    
    // Setting up IB Outlet connections for labels and buttons
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var loginBtnLbl: UIButton!
    @IBOutlet weak var signupToggleBtnLbl: UIButton!
    
    // Function that runs when the Sign-Up Here Toggle Button is pressed
    @IBAction func signupToggleBtnPressed(sender: AnyObject) {
        
        if signupActive == false {
            emailInput.alpha = 1
            loginBtnLbl.setTitle("Sign Up", forState: UIControlState.Normal)
            signupToggleBtnLbl.setTitle("Log in here !", forState: UIControlState.Normal)
            signupActive = true
            
        } else {
            emailInput.alpha = 0
            loginBtnLbl.setTitle("Log In", forState: UIControlState.Normal)
            signupToggleBtnLbl.setTitle("Sign up here !", forState: UIControlState.Normal)
            signupActive = false
        }
    }
    
    // Function that runs when the Login/Sign up button is pressed
    @IBAction func loginSignupBtn(sender: AnyObject) {
        if signupActive == true {
            
            if usernameInput.text == "" || emailInput.text == "" || passwordInput.text == ""{
                displayAlert("Missing Input", message: "You need to give input for all three fields")
            } else if countElements(passwordInput.text) < 8 {
                displayAlert("Password Length", message: "Please note that your password needs to consist of at least 8 charcaters")
            } else {
                var user = PFUser()
                user.username = usernameInput.text
                user.email = emailInput.text
                user.password = passwordInput.text
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, signupError: NSError!) -> Void in
                    if signupError == nil {
                        self.performSegueWithIdentifier("profilePic", sender: self)
                    } else {
                        if let errorString = signupError.userInfo?["error"] as? NSString{
                            self.displayAlert("Error in Form", message: errorString)
                            
                        } else {
                            self.displayAlert("Error", message: "Some unidentified error. Please try again!")
                        }
                        
                    }
                }
            }
            
        } else {
            
            PFUser.logInWithUsernameInBackground(usernameInput.text, password:passwordInput.text) {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    println("Login as \(user.username) is successful")
                    self.jumpToUserTable()
                    
                } else {
                    self.displayAlert("Log In Error", message: "Please make sure you input the right username and password")
                }
            }
            
        }

    }
    
    // Function that calls the various UIAlert
    func displayAlert(title: String, message: String){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func jumpToUserTable() {
        
        if PFUser.currentUser() != nil {
            performSegueWithIdentifier("userTable", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial set-up for Login page
        emailInput.alpha = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

