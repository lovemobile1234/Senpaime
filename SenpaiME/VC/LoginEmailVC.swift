//
//  LoginEmailVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/20/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginEmailVC: UIViewController {
    
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var btn_Create: UIButton!
    @IBOutlet weak var btn_Forgot: UIButton!
    @IBOutlet weak var btn_Next: UIButton!
    
    var cAddress = String()
    var cLat = String()
    var cLng = String()
    
    let createAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : customFont.AvenirMedium16!,
        NSAttributedString.Key.foregroundColor : RedColor0,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    //.styleDouble.rawValue, .styleThick.rawValue, .styleNone.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let attributeString = NSMutableAttributedString(string: "Create Account",
                                                        attributes: createAttributes)
        btn_Create.setAttributedTitle(attributeString, for: .normal)
        
        let attributeForgotString = NSMutableAttributedString(string: "Forgot Password?",
                                                        attributes: createAttributes)
        btn_Forgot.setAttributedTitle(attributeForgotString, for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func emailTextViewDidChanged(_ sender: Any) {
        
    }
    
    @IBAction func passwordTextViewDidChanged(_ sender: Any) {
        
    }
    
    @IBAction func onActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActionCreate(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "SignupEmailVC") as! SignupEmailVC
        VC.cAddress = self.cAddress
        VC.cLat = self.cLat
        VC.cLng = self.cLng
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func onActionForgot(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        VC.emailStr = self.tf_Email.text!
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func onActionNext(_ sender: Any) {
        if (tf_Email.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please enter your email.", comment: "masss"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }else if !isValidEmail(testStr: tf_Email.text!) {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please enter the valid email.", comment: "masss"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }else if (tf_Password.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please enter the password.", comment: "masss"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        AppManager.shared.showLoadingIndicator(view: self.view)
        
        Auth.auth().signIn(withEmail: tf_Email.text!, password: tf_Password.text!) { (result, error) in
            
            AppManager.shared.hideLoadingIndicator()
            
            if let error = error {
                
                AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                return
                
            }
            User.info(forUserID: (Auth.auth().currentUser?.uid)!, completion: { (User) in
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.navigationController?.pushViewController(VC, animated: true)
            })
            
            
        }
        
        
    }
}
