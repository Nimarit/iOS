//
//  ViewController.swift
//  Schedj
//
//  Created by Nimarit Walia on 4/22/16.
//  Copyright © 2016 Nimarit Walia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("Nim, you have an error seguing into HomeViewController...please handle.")
            self.performSegueWithIdentifier("home", sender: nil)
            // GO TO HOME PAGE (HomeViewController)
        }
        else
        {
            loginButton.center = self.view.center
            self.view!.addSubview(loginButton)
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.delegate = self
            
            animator = UIDynamicAnimator(referenceView: view)
            gravity = UIGravityBehavior(items: [loginButton])
            animator.addBehavior(gravity)
            collision = UICollisionBehavior(items: [loginButton])
            collision.translatesReferenceBoundsIntoBoundary = true
            animator.addBehavior(collision)
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        configureButton(signInButton)
        configureButton(registerButton)
    }
    
    func configureButton(button: UIButton) {
        button.layer.cornerRadius = button.bounds.size.width / 50
        button.clipsToBounds = true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            print("Error: \(error)...please handle Nims.")
        }
        else if result.isCancelled {
            print("Nims, you have a cancellation...please handle.")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if (!result.grantedPermissions.contains("public_profile") || !result.grantedPermissions.contains("email") || !result.grantedPermissions.contains("user_friends"))
            {
                print("Error in retrieving granted Permissions...please try logging in again.")
            }
        }
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
                let friendList : NSArray = result.valueForKey("user_friends") as! NSArray
                print("First Friend for \(userName) is \(friendList[0])")
            }
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

