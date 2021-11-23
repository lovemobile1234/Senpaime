//
//  OtherProfileVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/26/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OtherProfileVC: UIViewController {
    
    @IBOutlet weak var img_ProfilePic: UIImageView!
    @IBOutlet weak var lbl_NameAge: UILabel!
    
    @IBOutlet weak var lbl_Watching: UILabel!
    @IBOutlet weak var lbl_Mangas: UILabel!
    @IBOutlet weak var lbl_Cosplay: UILabel!
    @IBOutlet weak var lbl_Attending: UILabel!
    @IBOutlet weak var lbl_About: UILabel!
    
    @IBOutlet weak var constraint_WatchingH: NSLayoutConstraint!
    @IBOutlet weak var constraint_MangasH: NSLayoutConstraint!
    @IBOutlet weak var constraint_CosplayH: NSLayoutConstraint!
    @IBOutlet weak var constraint_AttendingH: NSLayoutConstraint!
    @IBOutlet weak var constraint_AboutH: NSLayoutConstraint!
    
    var userDic: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUserProfileView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func setUserProfileView() {
        
        self.lbl_NameAge.text = userDic!.first_name + ", " + userDic!.age
        let userPics = userDic!.user_pics
        if userPics.count > 0 {
            let userPic1 = userPics[0]
            self.img_ProfilePic.sd_setShowActivityIndicatorView(true)
            self.img_ProfilePic.sd_setIndicatorStyle(.whiteLarge)
            self.img_ProfilePic.sd_setImage(with: URL(string: userPic1), placeholderImage: UIImage(named: "profile_icon"))
        }
        
        let sWidth = self.view.bounds.width - 55
        
        lbl_Watching.text = userDic!.watching
        lbl_Mangas.text = userDic!.mangas
        lbl_Cosplay.text = userDic!.cosplay
        lbl_Attending.text = userDic!.attending
        lbl_About.text = userDic!.about
        
        constraint_WatchingH.constant = heightForView(text: lbl_Watching.text!, font: customFont.AvenirLight14!, width: sWidth) < 25 ? 25 : heightForView(text: lbl_Watching.text!, font: customFont.AvenirLight14!, width: sWidth)
        constraint_MangasH.constant = heightForView(text: lbl_Mangas.text!, font: customFont.AvenirLight14!, width: sWidth) < 25 ? 25 : heightForView(text: lbl_Mangas.text!, font: customFont.AvenirLight14!, width: sWidth)
        constraint_CosplayH.constant = heightForView(text: lbl_Cosplay.text!, font: customFont.AvenirLight14!, width: sWidth) < 25 ? 25 : heightForView(text: lbl_Cosplay.text!, font: customFont.AvenirLight14!, width: sWidth)
        constraint_AttendingH.constant = heightForView(text: lbl_Attending.text!, font: customFont.AvenirLight14!, width: sWidth) < 25 ? 25 : heightForView(text: lbl_Attending.text!, font: customFont.AvenirLight14!, width: sWidth)
        constraint_AboutH.constant = heightForView(text: lbl_About.text!, font: customFont.AvenirLight14!, width: sWidth) < 25 ? 25 : heightForView(text: lbl_About.text!, font: customFont.AvenirLight14!, width: sWidth)
    }
    
    @IBAction func onActionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
