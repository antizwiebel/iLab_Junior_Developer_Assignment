//
//  TouchIdViewController.swift
//  iLAB_iOS_Junior_Developer_Assignment
//
//  Created by Laureen Schausberger on 26/10/2017.
//  Copyright © 2017 Mark Peneder. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIdViewController: UIViewController {

    let kMsgShowFinger = "Tap to login"
    let kMsgShowReason = "Please login with your TouchID"
    let kMsgFingerOK = "Login successful! ✅"
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var touchIdImageView: UIImageView!
    
    var context = LAContext()
    var policy: LAPolicy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    func updateUI() {
        
        // Depending the iOS version we'll need to choose the policy we are able to use
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        } else {
            // iOS 8+ users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = "Fuu!"
            policy = .deviceOwnerAuthenticationWithBiometrics
        }
        
        var err: NSError?
        
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            touchIdImageView.image = UIImage(named: "TouchID_off")
            // Print the localized message received by the system
            message.text = err?.localizedDescription
            print(err?.localizedDescription ?? "")
            return
        }
        
        //The user is able to use his/her Touch ID 
        login.isEnabled = true
        touchIdImageView.image = UIImage(named: "TouchID_on")
        message.text = kMsgShowFinger
        
    }
    
    
    
    private func loginProcess(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: kMsgShowReason, reply: { (success, error) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.login.alpha = 1
                })
                
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessage()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.message.text = "There was a problem verifying your identity."
                    case LAError.userCancel:
                        self.message.text = "Authentication was canceled by user."
                        // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                    // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                    case LAError.userFallback:
                        self.message.text = "The user tapped the fallback button (Fuu!)"
                    case LAError.systemCancel:
                        self.message.text = "Authentication was canceled by system."
                    case LAError.passcodeNotSet:
                        self.message.text = "Passcode is not set on the device."
                    case LAError.touchIDNotAvailable:
                        self.message.text = "Touch ID is not available on the device."
                    case LAError.touchIDNotEnrolled:
                        self.message.text = "Touch ID has no enrolled fingers."
                    // iOS 9+ functions
                    case LAError.touchIDLockout:
                        self.message.text = "There were too many failed Touch ID attempts and Touch ID is now locked."
                    case LAError.appCancel:
                        self.message.text = "Authentication was canceled by application."
                    case LAError.invalidContext:
                        self.message.text = "LAContext passed to this call has been previously invalidated."
                    default:
                        self.message.text = "Touch ID may not be configured"
                        break
                    }
                    return
                }
                
                // Everything went fine
                self.performSegue(withIdentifier: "showMap", sender: self)
                self.message.text = self.kMsgFingerOK
            }
        })
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginProcess(policy: policy!)
    }
    
    private func showUnexpectedErrorMessage() {
        touchIdImageView.image = UIImage(named: "TouchID_off")
        message.text = "Unexpected error! 😱"
    }
    
}
