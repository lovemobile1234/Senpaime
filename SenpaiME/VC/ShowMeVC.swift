//
//  ShowMeVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/23/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShowMeVC: UIViewController {
    
    @IBOutlet weak var img_Chk_Men: UIImageView!
    @IBOutlet weak var img_Chk_Women: UIImageView!
    @IBOutlet weak var img_Chk_Both: UIImageView!
    
    @IBOutlet weak var lbl_Men: UILabel!
    @IBOutlet weak var lbl_Women: UILabel!
    @IBOutlet weak var lbl_Both: UILabel!
    
    
    var showMe = String()
    var selectedShowMe = String()
    
    var databaseRef = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        
        selectedShowMe = showMe
        self.unSelectBtn()
        if showMe == "Men" {
            img_Chk_Men.isHidden = false
            lbl_Men.textColor = RedColor0
            lbl_Men.font = customFont.AvenirHeavy16
        }else if showMe == "Women" {
            img_Chk_Women.isHidden = false
            lbl_Women.textColor = RedColor0
            lbl_Women.font = customFont.AvenirHeavy16
        }else if showMe == "Men and Women" {
            img_Chk_Both.isHidden = false
            lbl_Both.textColor = RedColor0
            lbl_Both.font = customFont.AvenirHeavy16
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func onActionBack(_ sender: Any) {
        if showMe == selectedShowMe {
            self.navigationController?.popViewController(animated: true)
        }else {
            AppManager.shared.showLoadingIndicator(view: self.view)
            let params = ["show_gender": selectedShowMe] as [String : Any]
            
            self.databaseRef.child(DatabaseKeys.users).child(Auth.auth().currentUser!.uid).updateChildValues(params) { (error, ref) in
                
                if let error = error {
                    AppManager.shared.hideLoadingIndicator()
                    try! Auth.auth().signOut()
                    AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                }
                
                User.info(forUserID: (Auth.auth().currentUser?.uid)!, completion: { (User) in
                    AppManager.shared.hideLoadingIndicator()
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @IBAction func onActionMen(_ sender: Any) {
        self.unSelectBtn()
        img_Chk_Men.isHidden = false
        lbl_Men.textColor = RedColor0
        lbl_Men.font = customFont.AvenirHeavy16
        selectedShowMe = "Men"
    }
    
    @IBAction func onActionWomen(_ sender: Any) {
        self.unSelectBtn()
        img_Chk_Women.isHidden = false
        lbl_Women.textColor = RedColor0
        lbl_Women.font = customFont.AvenirHeavy16
        selectedShowMe = "Women"
    }
    
    @IBAction func onActionBoth(_ sender: Any) {
        self.unSelectBtn()
        img_Chk_Both.isHidden = false
        lbl_Both.textColor = RedColor0
        lbl_Both.font = customFont.AvenirHeavy16
        selectedShowMe = "Men and Women"
    }
    
    func unSelectBtn() {
        img_Chk_Men.isHidden = true
        img_Chk_Women.isHidden = true
        img_Chk_Both.isHidden = true
        
        lbl_Men.textColor = .gray
        lbl_Women.textColor = .gray
        lbl_Both.textColor = .gray
        lbl_Men.font = customFont.AvenirLight16
        lbl_Women.font = customFont.AvenirLight16
        lbl_Both.font = customFont.AvenirLight16
    }

}

