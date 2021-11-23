//
//  SignupEmailVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/20/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit

class SignupEmailVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var btn_Next: UIButton!
    
    var cAddress = String()
    var cLat = String()
    var cLng = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btn_Next.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if isValidEmail(testStr: textField.text!) {
            btn_Next.setImage(UIImage(named: "btn_next_active"), for: .normal)
            btn_Next.isEnabled = true
        }else {
            btn_Next.setImage(UIImage(named: "btn_next_inactive"), for: .normal)
            btn_Next.isEnabled = false
        }
    }
    
    
    @IBAction func onActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActionNext(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "SignupPasswordVC") as! SignupPasswordVC
        VC.emailStr = tf_Email.text!
        VC.cAddress = self.cAddress
        VC.cLat = self.cLat
        VC.cLng = self.cLng
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
}
