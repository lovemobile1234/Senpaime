//
//  SignupGenderVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/23/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit

class SignupGenderVC: UIViewController {
    
    @IBOutlet weak var tf_Gender: UITextField!
    @IBOutlet weak var btn_Next: UIButton!
    
    var emailStr = String()
    var passwordStr = String()
    var nameStr = String()
    
    var cAddress = String()
    var cLat = String()
    var cLng = String()
    
    let gendersArray = ["Male", "Female"]
    
    let genderPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        genderPicker.backgroundColor = .white
        
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
        tf_Gender.inputAccessoryView = toolbar
        // add datepicker to textField
        tf_Gender.inputView = genderPicker
    }
    
    @objc func donedatePicker(){
        let row = genderPicker.selectedRow(inComponent: 0)
        tf_Gender.text = gendersArray[row]
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
        
        if (tf_Gender.text?.isEmpty)! {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please select your gender.", comment: "masss"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "SignupAgeVC") as! SignupAgeVC
        VC.emailStr = emailStr
        VC.passwordStr = passwordStr
        VC.nameStr = nameStr
        VC.genderStr = tf_Gender.text!
        VC.cAddress = self.cAddress
        VC.cLat = self.cLat
        VC.cLng = self.cLng
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}


extension SignupGenderVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gendersArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gendersArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tf_Gender.text = gendersArray[row]
    }
    
}
