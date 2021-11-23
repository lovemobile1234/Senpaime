//
//  ForgotPassVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/30/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ForgotPassVC: UIViewController {
    
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var btn_Reset: UIButton!
    
    var emailStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tf_Email.text = emailStr
        btn_Reset.backgroundColor = .lightGray
        btn_Reset.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if isValidEmail(testStr: textField.text!) {
            btn_Reset.backgroundColor = RedColor0
            btn_Reset.isEnabled = true
        }else {
            btn_Reset.backgroundColor = .lightGray
            btn_Reset.isEnabled = false
        }
    }
    
    @IBAction func onActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActionReset(_ sender: Any) {
        AppManager.shared.showLoadingIndicator(view: self.view)
        Auth.auth().sendPasswordReset(withEmail: tf_Email.text!) { (error) in
            AppManager.shared.hideLoadingIndicator()
            if error == nil {
                let alert = UIAlertController(title: "Check your email \(self.tf_Email.text!)", message: NSLocalizedString("To reset your password, follow the instructions in the email.\n(If you don't receive an email, please also check your junk mailbox.)", comment: "masss"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }else {
                AppManager.shared.showAlert(msg: error!.localizedDescription, activity: self)
            }
        }
        
        
    }
}
