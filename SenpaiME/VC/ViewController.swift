//
//  ViewController.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/8/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import GooglePlaces

let storyboard:UIStoryboard      = UIStoryboard(name: "Main", bundle: nil)
let RedColor0 = UIColor(red: 1.0, green: 84.0/255.0, blue: 92.0/255.0, alpha: 1.0)
let RedColor07 = UIColor(red: 1.0, green: 84.0/255.0, blue: 92.0/255.0, alpha: 0.7)

class ViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var scr_View: UIScrollView!
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    @IBOutlet weak var btn_Fb: UIButton!
    
    @IBOutlet weak var lbl_NeverPostFB: UILabel!
    @IBOutlet weak var lbl_Agree: UILabel!
    
    @IBOutlet weak var constraint_ScrollTop: NSLayoutConstraint!
    
    @IBOutlet weak var btn_Email: UIButton!
    
    var scr_Timer = Timer()
    
    var cAddress = String()
    var cLat = String()
    var cLng = String()
    
    let emailAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : customFont.AvenirMedium18!,
        NSAttributedString.Key.foregroundColor : RedColor0,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    //.styleDouble.rawValue, .styleThick.rawValue, .styleNone.rawValue
    
    let locationManager = CLLocationManager()
    
    var databaseRef = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        locationManager.delegate = self
        
        if Auth.auth().currentUser != nil {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(VC, animated: false)
        }
        
        
        databaseRef = Database.database().reference()
        let attributeString = NSMutableAttributedString(string: "Log in with Email",
                                                        attributes: emailAttributes)
        btn_Email.setAttributedTitle(attributeString, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadIntroView()
        scr_Timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }else {
            self.getCurrentLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        scr_Timer.invalidate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let layerWidth:CGFloat = self.view.bounds.width
//        let scrollH:CGFloat = self.introScrollView.bounds.height
//        self.introScrollView.contentSize = CGSize(width: layerWidth*CGFloat(introArray.count), height: scrollH)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            print("authorizedWhenInUse")
            self.getCurrentLocation()
        }
    }
    
    func getCurrentLocation() {
        let placesClient = GMSPlacesClient.shared()
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    //                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    //                    print("Current Place address = \(place.formattedAddress)")
                    //                    print("Current Place attributions \(place.attributions)")
                    //                    print("Current PlaceID \(place.placeID)")
                    
                    let address:String = place.formattedAddress!
//                    let addressArr = address.components(separatedBy: ", ")
                    self.cAddress = address
                    self.cLat = String(place.coordinate.latitude)
                    self.cLng = String(place.coordinate.longitude)
                }
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
        let pageIndex = round(scrollView.contentOffset.x/self.view.frame.width)
        pageCtrl.currentPage = Int(pageIndex)
    }
    
    @objc func timerAction() {
        let sWidth:CGFloat = self.view.bounds.width
        if scr_View.contentOffset.x >= sWidth*3 {
            self.scr_View.setContentOffset(CGPoint(x:0, y:0), animated: true)
        }else {
            let xOffSet = scr_View.contentOffset.x+sWidth;
            self.scr_View.setContentOffset(CGPoint(x:xOffSet, y:0), animated: true)
        }
    }
    
    func loadIntroView() {
        let sWidth = self.view.bounds.width
        let sHeight = self.view.bounds.height
        
        if DeviceType.iPhoneX {
            constraint_ScrollTop.constant = 45.0
        }else {
            constraint_ScrollTop.constant = 0
        }
        
        for index in 0...3 {
            
            let introView = UIView()
            if DeviceType.iPhoneX {
                introView.frame = CGRect(x: CGFloat(index)*sWidth, y: 0.0, width: sWidth, height: sHeight-250)
            }else {
                introView.frame = CGRect(x: CGFloat(index)*sWidth, y: 0.0, width: sWidth, height: sHeight-220)
            }
            
            
            let introImgView = UIImageView()
            if DeviceType.iPhoneX {
                introImgView.frame = CGRect(x: 0.0, y: 0.0, width: sWidth, height: sHeight-250)
            }else {
                introImgView.frame = CGRect(x: 0.0, y: 0.0, width: sWidth, height: sHeight-220)
            }
            
            introImgView.image = UIImage(named: ("intro"+String(index+1)))
            introImgView.contentMode = .scaleAspectFill
            introImgView.clipsToBounds = true
            introView.addSubview(introImgView)
            
            if index == 0 {
                let introTitle = UILabel()
                if DeviceType.iPhoneX {
                    introTitle.frame = CGRect(x: 30.0, y: sHeight-330, width: sWidth-60.0, height: 45.0)
                }else {
                    introTitle.frame = CGRect(x: 30.0, y: sHeight-290, width: sWidth-60.0, height: 45.0)
                }
                introTitle.text = "Meet. Talk. COSPLAY."
                introTitle.font = customFont.AvenirBlack24
                introTitle.backgroundColor = RedColor0
                introTitle.textColor = .white
                introTitle.textAlignment = .center
                introView.addSubview(introTitle)
            }else if index == 1 {
                let introTitle1 = UILabel()
                if DeviceType.iPhoneX {
                    introTitle1.frame = CGRect(x: 30.0, y: sHeight-385, width: sWidth-60.0, height: 45.0)
                }else {
                    introTitle1.frame = CGRect(x: 30.0, y: sHeight-345, width: sWidth-60.0, height: 45.0)
                }
                introTitle1.text = "A Dating App Made"
                introTitle1.font = customFont.AvenirBlack24
                introTitle1.backgroundColor = RedColor0
                introTitle1.textColor = .white
                introTitle1.textAlignment = .center
                introView.addSubview(introTitle1)
                
                let introTitle2 = UILabel()
                if DeviceType.iPhoneX {
                    introTitle2.frame = CGRect(x: 30.0, y: sHeight-330, width: sWidth-60.0, height: 45.0)
                }else {
                    introTitle2.frame = CGRect(x: 30.0, y: sHeight-290, width: sWidth-60.0, height: 45.0)
                }
                introTitle2.text = "For Anime Fans!"
                introTitle2.font = customFont.AvenirBlack24
                introTitle2.backgroundColor = RedColor0
                introTitle2.textColor = .white
                introTitle2.textAlignment = .center
                introView.addSubview(introTitle2)
            }else if index == 2 {
                let introTitle1 = UILabel()
                if DeviceType.iPhoneX {
                    introTitle1.frame = CGRect(x: 30.0, y: sHeight-385, width: sWidth-60.0, height: 45.0)
                }else {
                    introTitle1.frame = CGRect(x: 30.0, y: sHeight-345, width: sWidth-60.0, height: 45.0)
                }
                introTitle1.text = "Share Manga"
                introTitle1.font = customFont.AvenirBlack24
                introTitle1.backgroundColor = RedColor0
                introTitle1.textColor = .white
                introTitle1.textAlignment = .center
                introView.addSubview(introTitle1)
                
                let introTitle2 = UILabel()
                if DeviceType.iPhoneX {
                    introTitle2.frame = CGRect(x: 30.0, y: sHeight-330, width: sWidth-60.0, height: 45.0)
                }else {
                    introTitle2.frame = CGRect(x: 30.0, y: sHeight-290, width: sWidth-60.0, height: 45.0)
                }
                introTitle2.text = "Moments Together!"
                introTitle2.font = customFont.AvenirBlack24
                introTitle2.backgroundColor = RedColor0
                introTitle2.textColor = .white
                introTitle2.textAlignment = .center
                introView.addSubview(introTitle2)
            }else if index == 3 {
                let introTitle = UILabel()
                if DeviceType.iPhoneX {
                    introTitle.frame = CGRect(x: 30.0, y: sHeight-330, width: sWidth-60.0, height: 45.0)
                }else {
                    introTitle.frame = CGRect(x: 30.0, y: sHeight-290, width: sWidth-60.0, height: 45.0)
                }
                introTitle.text = "Find Your Senpai!"
                introTitle.font = customFont.AvenirBlack24
                introTitle.backgroundColor = RedColor0
                introTitle.textColor = .white
                introTitle.textAlignment = .center
                introView.addSubview(introTitle)
            }
            
            
            self.scr_View.addSubview(introView)
            
            
        }
        self.scr_View.contentSize = CGSize(width: sWidth*4.0, height: sWidth*1.2)
        self.scr_View.isPagingEnabled = true
        
    }
    
    @IBAction func onActionFB(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print(grantedPermissions)
                print(declinedPermissions)
                print("Logged in!")
                UserDefaults.standard.set(accessToken.authenticationToken, forKey: "token")
                
                AppManager.shared.showLoadingIndicator(view: self.view)
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        
                        AppManager.shared.hideLoadingIndicator()
                        AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                        
                        return
                    }
                    
                    
                    self.databaseRef.child(DatabaseKeys.users).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if !snapshot.exists() {
                            
                            self.getUserInfo()
                            
                        }else {
                            
                            AppManager.shared.hideLoadingIndicator()
                            
                            User.info(forUserID: (Auth.auth().currentUser?.uid)!, completion: { (User) in
                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                self.navigationController?.pushViewController(VC, animated: true)
                            })
                        }
                        
                    }, withCancel: { (error) in
                        
                        try! Auth.auth().signOut()
                        AppManager.shared.hideLoadingIndicator()
                        AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                        
                    })
                }
            }
        }
        

    }
    
    func getUserInfo(){
        
        let params = ["fields" : "id, name, first_name, last_name, picture.width(720).height(720), email, gender, location, age_range, birthday"]
        let graphRequest = FBSDKGraphRequest.init(graphPath: "/me", parameters: params)
        let Connection = FBSDKGraphRequestConnection()
        Connection.add(graphRequest) { (Connection, result, error) in
            
            if let error = error {
                
                try! Auth.auth().signOut()
                AppManager.shared.hideLoadingIndicator()
                AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                
                return
            }
            
            self.databaseRef.child(DatabaseKeys.users).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    AppManager.shared.hideLoadingIndicator()
                    
                    User.info(forUserID: (Auth.auth().currentUser?.uid)!, completion: { (User) in
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(VC, animated: true)
                    })
                    return
                    
                }
                
                let info = result as! [String : AnyObject]
                
                let userPicDic = info["picture"] as? [String : Any]
                let userPicData = userPicDic!["data"] as? [String : Any]
                let userPic = userPicData!["url"] as? String ?? ""
                let ageRange = info["age_range"] as? [String : Any] ?? ["" : ""]
                
                let params = ["first_name": info["first_name"] as! String,
                              "last_name": info["last_name"] as! String,
                              "email": info["email"] as! String,
                              "user_pics": [userPic, "", "", "", ""],
                              "gender": info["gender"] as? String ?? "Unknown",
                              "location": self.cAddress,
                              "coor_lat": self.cLat,
                              "coor_lng": self.cLng,
                              "age": ageRange["min"] as? String ?? "",
                              "uid": Auth.auth().currentUser!.uid,
                              "show_distance": "100",
                              "show_gender": "Men and Women",
                              "show_age": "18-45",
                              "isfacebook": "1"] as [String : Any]
                
                
                print(params)
                
                self.databaseRef.child(DatabaseKeys.users).child(Auth.auth().currentUser!.uid).setValue(params, withCompletionBlock: { (error, ref) in
                    
                    if let error = error {
                        
                        try! Auth.auth().signOut()
                        AppManager.shared.hideLoadingIndicator()
                        AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                        
                        return
                    }
                    
                    AppManager.shared.hideLoadingIndicator()
                    
                    User.info(forUserID: (Auth.auth().currentUser?.uid)!, completion: { (User) in
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(VC, animated: true)
                    })
                    
                })
                
            }, withCancel: { (error) in
                
                try! Auth.auth().signOut()
                AppManager.shared.hideLoadingIndicator()
                AppManager.shared.showAlert(msg: error.localizedDescription, activity: self)
                
            })
            
        }
        Connection.start()
        
    }
    
    @IBAction func onActionEmail(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "LoginEmailVC") as! LoginEmailVC
        VC.cAddress = self.cAddress
        VC.cLat = self.cLat
        VC.cLng = self.cLng
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

