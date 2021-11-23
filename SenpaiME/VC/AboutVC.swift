//
//  AboutVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/14/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var lbl_Version: UILabel!
    @IBOutlet weak var lbl_New: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    @IBAction func onActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActionRate(_ sender: Any) {
        rateApp(appId: "id547702041") { success in
            print("RateApp \(success)")
        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    @IBAction func onActionTerms(_ sender: Any) {
        guard let url = URL(string : "https://www.senpaime.com/terms") else {
            return
        }
        guard #available(iOS 10, *) else {
            UIApplication.shared.openURL(url)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func onActionPrivacy(_ sender: Any) {
        guard let url = URL(string : "https://www.senpaime.com/privacy") else {
            return
        }
        guard #available(iOS 10, *) else {
            UIApplication.shared.openURL(url)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func onActionAbout(_ sender: Any) {
        guard let url = URL(string : "https://www.senpaime.com/") else {
            return
        }
        guard #available(iOS 10, *) else {
            UIApplication.shared.openURL(url)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    
    
}
