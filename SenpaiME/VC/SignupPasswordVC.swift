//
//  SignupPasswordVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/20/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit

class SignupPasswordVC: UIViewController {
    
    @IBOutlet weak var tf_Password: UITextField!
    @IBOutlet weak var btn_Next: UIButton!
    @IBOutlet weak var lbl_Error: UILabel!
    
    var emailStr = String()
    
    var cAddress = String()
    var cLat = String()
    var cLng = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btn_Next.isEnabled = false
        lbl_Error.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if (textField.text?.count)! >= 8 {
            btn_Next.setImage(UIImage(named: "btn_next_active"), for: .normal)
            btn_Next.isEnabled = true
            lbl_Error.isHidden = true
        }else {
            btn_Next.setImage(UIImage(named: "btn_next_inactive"), for: .normal)
            btn_Next.isEnabled = false
            lbl_Error.isHidden = false
        }
    }
    
    @IBAction func onActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActionNext(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "SignupNameVC") as! SignupNameVC
        VC.emailStr = emailStr
        VC.passwordStr = tf_Password.text!
        VC.cAddress = self.cAddress
        VC.cLat = self.cLat
        VC.cLng = self.cLng
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}
