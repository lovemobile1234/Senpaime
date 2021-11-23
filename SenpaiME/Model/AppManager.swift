//
//  AppManager.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/21/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import MBProgressHUD

final class AppManager {
    
    static let shared: AppManager = {
        return AppManager()
    }()
    
    var loadingNotification: MBProgressHUD!
    
    private init() { }
    
    func showAlert(msg: String, activity: UIViewController) -> Void {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        activity.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, msg: String, activity: UIViewController) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        activity.present(alert, animated: true, completion: nil)
    }
    
    func showLoadingIndicator(view: UIView){
        loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.bezelView.color = RedColor0
        loadingNotification.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    func hideLoadingIndicator(){
        loadingNotification.hide(animated: true)
    }

}
