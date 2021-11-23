//
//  SettingsVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/14/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GooglePlaces
import TTRangeSlider

class SettingsVC: UIViewController {
    
    @IBOutlet weak var slider_Distance: TTRangeSlider!
    @IBOutlet weak var slider_Age: TTRangeSlider!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_ShowMe: UILabel!
    
    var userDic:User? = nil
    
    var originDistance = String()
    var originAge = String()
    var selectedDistance = String()
    var selectedAge = String()
    
    var cLat:String = ""
    var cLng:String = ""
    
    var databaseRef = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        slider_Distance.delegate = self
        slider_Age.delegate = self
        
        let customFormatter = NumberFormatter()
        customFormatter.positiveSuffix = " mi"
        slider_Distance.numberFormatterOverride = customFormatter

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: StaticDATA.currentUser) != nil {
            let decoded  = userDefaults.object(forKey: StaticDATA.currentUser) as! Data
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
            self.userDic = decodedUser
            self.setSettingsView()
        }
    }
    
    func setSettingsView() {
        lbl_Location.text = userDic?.location
        lbl_ShowMe.text = userDic?.show_gender
        
        
        let showDistance:String = userDic?.show_distance == "" ? "100" : (userDic?.show_distance)!
        slider_Distance.selectedMaximum = Float(showDistance)!
        let showAges:String = userDic?.show_age == "" ? "18-45" : (userDic?.show_age)!
        let showAgesArr = showAges.components(separatedBy: "-")
        slider_Age.selectedMinimum = Float(showAgesArr[0])!
        slider_Age.selectedMaximum = Float(showAgesArr[1])!
        
        originDistance = showDistance
        originAge = showAges
        selectedDistance = originDistance
        selectedAge = originAge
    }
    
    @IBAction func onActionBack(_ sender: Any) {
        if (originDistance != selectedDistance) || (originAge != selectedAge) {
            AppManager.shared.showLoadingIndicator(view: self.view)
            let params = ["show_distance": selectedDistance,
                          "show_age": selectedAge] as [String : Any]
            
            
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
        }else {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @IBAction func onActionLocation(_ sender: Any) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onActionShowMe(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "ShowMeVC") as! ShowMeVC
        VC.showMe = (userDic?.show_gender)!
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func onActionAbout(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func onActionInviteFriends(_ sender: Any) {
        let text = "Hey, check out this app I'm using called SenpaiME! It's awesome!\n\nhttps://itunes.apple.com/us/app/tinder/id547702041?mt=8"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onActionSignout(_ sender: Any) {
        try! Auth.auth().signOut()
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: StaticDATA.currentUser)
        userDefaults.synchronize()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension SettingsVC: TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        if sender == slider_Distance {
            self.selectedDistance = String(Int(round(selectedMaximum)))
            print("Dis-", self.selectedDistance)
        }else if sender == slider_Age {
            self.selectedAge = "\(Int(round(selectedMinimum)))-\(Int(round(selectedMaximum)))"
            print("Age-", self.selectedAge)
        }
    }
}

extension SettingsVC: GMSAutocompleteViewControllerDelegate {
    
    func updateLocation() {
        
    }
    
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        print("Place name: \(place.name)")
        //        print("Place address: \(place.formattedAddress)")
        //        print("Place attributions: \(place.attributions)")
        //        var myCountry = ""
        let myAddress = place.formattedAddress ?? ""
        //        let mycname = myAddress.components(separatedBy: ", ")
        //        if mycname.count > 0 {
        //            myCountry = mycname.last!
        //        }else {
        //            myCountry = myAddress
        //        }
        lbl_Location.text = myAddress
        self.cLat = String(place.coordinate.latitude)
        self.cLng = String(place.coordinate.longitude)
        
        AppManager.shared.showLoadingIndicator(view: self.view)
        let params = ["location": lbl_Location.text!,
                      "coor_lat": self.cLat,
                      "coor_lng": self.cLng] as [String : Any]
        
        self.databaseRef.child(DatabaseKeys.users).child(Auth.auth().currentUser!.uid).updateChildValues(params) { (error, ref) in
            
            if let error = error {
                AppManager.shared.hideLoadingIndicator()
                try! Auth.auth().signOut()
                AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                viewController.dismiss(animated: true, completion: nil)
                return
            }
            
            User.info(forUserID: (Auth.auth().currentUser?.uid)!, completion: { (User) in
                AppManager.shared.hideLoadingIndicator()
                viewController.dismiss(animated: true, completion: nil)
            })
        }
        
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
