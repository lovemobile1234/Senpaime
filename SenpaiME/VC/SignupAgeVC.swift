//
//  SignupAgeVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/20/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupAgeVC: UIViewController {
    
    @IBOutlet weak var tf_Age: UITextField!
    @IBOutlet weak var btn_Next: UIButton!
    
    let agePicker = UIPickerView()
    
    var emailStr = String()
    var passwordStr = String()
    var nameStr = String()
    var genderStr = String()
    
    var cAddress = String()
    var cLat = String()
    var cLng = String()
    
    var databaseRef = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        databaseRef = Database.database().reference()
        
        agePicker.delegate = self
        agePicker.dataSource = self
        
        agePicker.backgroundColor = .white
        
        self.setPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func setPicker(){
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        tf_Age.inputAccessoryView = toolbar
        // add datepicker to textField
        tf_Age.inputView = agePicker
    }
    
    @objc func donedatePicker() {
        let row = agePicker.selectedRow(inComponent: 0)
        tf_Age.text = String(row+18)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    @IBAction func onActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActionNext(_ sender: Any) {
        if (tf_Age.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please select your age.", comment: "masss"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        AppManager.shared.showLoadingIndicator(view: self.view)
        
        Auth.auth().createUser(withEmail: emailStr, password: passwordStr) { (result, error) in
            
            if let error = error{
                
                AppManager.shared.hideLoadingIndicator()
                AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                return
                
            }
            
            let params = ["first_name": self.nameStr,
                          "last_name": "",
                          "email": self.emailStr,
                          "user_pics": ["", "", "", "", ""],
                          "gender": self.genderStr,
                          "location": self.cAddress,
                          "coor_lat": self.cLat,
                          "coor_lng": self.cLng,
                          "age": self.tf_Age.text!,
                          "uid": Auth.auth().currentUser!.uid,
                          "show_distance": "100",
                          "show_gender": "Men and Women",
                          "show_age": "18-45",
                          "isfacebook": "0"] as [String : Any]
            
            self.databaseRef.child(DatabaseKeys.users).child(Auth.auth().currentUser!.uid).setValue(params, withCompletionBlock: { (error, ref) in
                
                AppManager.shared.hideLoadingIndicator()
                
                if let error = error {
                    
                    try! Auth.auth().signOut()
                    AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                    return
                    
                }
                
                User.info(forUserID: (Auth.auth().currentUser?.uid)!, completion: { (User) in
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(VC, animated: true)
                })
                
            })
            
        }
    }
    
    
}

extension SignupAgeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 43
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+18)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tf_Age.text = String(row+18)
    }
    
}
