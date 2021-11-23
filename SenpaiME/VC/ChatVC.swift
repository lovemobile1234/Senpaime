//
//  ChatVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/14/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import Photos
import Firebase
import CoreLocation
import IQKeyboardManagerSwift

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var img_ProfilePic: RoundedImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    
    
    //MARK: Properties
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
//    let locationManager = CLLocationManager()
    var items = [Message]()
//    let imagePicker = UIImagePickerController()
    let barHeight: CGFloat = DeviceType.iPhoneX ? 60 : 50
    var currentUser: User?
//    var canSendLocation = true
    
    
    //MARK: Methods
    func customization() {
//        self.imagePicker.delegate = self
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
//        self.navigationItem.title = self.currentUser?.first_name
//        self.navigationItem.setHidesBackButton(true, animated: false)
//        let icon = UIImage.init(named: "btn_back")?.withRenderingMode(.alwaysOriginal)
//        let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
//        self.navigationItem.leftBarButtonItem = backButton
//        self.locationManager.delegate = self
        if DeviceType.iPhoneX {
            self.bottomConstraint.constant = 10
        }else {
            self.bottomConstraint.constant = 0
        }
        
    }
    
    func setProfileView() {
        let userPics = currentUser!.user_pics
        let userPic1 = userPics[0]
        img_ProfilePic.sd_setShowActivityIndicatorView(true)
        img_ProfilePic.sd_setIndicatorStyle(.whiteLarge)
        img_ProfilePic.sd_setImage(with: URL(string: userPic1), placeholderImage: UIImage(named: "profile_icon"))
        lbl_Name.text = currentUser!.first_name + ", " + currentUser!.age
    }
    
    //Downloads messages
    func fetchData() {
        Message.downloadAllMessages(forUserID: self.currentUser!.uid, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
        })
        Message.markMessagesRead(forUserID: self.currentUser!.uid)
    }
    
    //Hides current viewcontroller
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    @IBAction func onActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onActionOtherProfile(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
        VC.userDic = self.currentUser
        self.navigationController?.present(VC, animated: true, completion: nil)
    }
    
    func composeMessage(type: MessageType, content: Any)  {
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message, toID: self.currentUser!.uid, completion: {(_) in
        })
    }
    
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
    
    func animateExtraButtons(toHide: Bool) {
        switch toHide {
        case true:
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        default:
            self.bottomConstraint.constant = -50
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func showMessage(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
    }
    
    @IBAction func selectGallery(_ sender: Any) {
//        self.animateExtraButtons(toHide: true)
//        let status = PHPhotoLibrary.authorizationStatus()
//        if (status == .authorized || status == .notDetermined) {
//            self.imagePicker.sourceType = .savedPhotosAlbum;
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
        
    }
    
    @IBAction func selectCamera(_ sender: Any) {
//        self.animateExtraButtons(toHide: true)
//        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
//        if (status == .authorized || status == .notDetermined) {
//            self.imagePicker.sourceType = .camera
//            self.imagePicker.allowsEditing = false
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
    }
    
    @IBAction func selectLocation(_ sender: Any) {
//        self.canSendLocation = true
//        self.animateExtraButtons(toHide: true)
//        if self.checkLocationPermission() {
//            self.locationManager.startUpdatingLocation()
//        } else {
//            self.locationManager.requestWhenInUseAuthorization()
//        }
    }
    
    @IBAction func showOptions(_ sender: Any) {
        self.animateExtraButtons(toHide: false)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            if text.count > 0 {
                self.composeMessage(type: .text, content: self.inputTextField.text!)
                self.inputTextField.text = ""
            }
        }
    }
    
    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
            if self.items.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items[indexPath.row].owner {
        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            switch self.items[indexPath.row].type {
            case .text:
                cell.message.text = self.items[indexPath.row].content as? String
            case .photo:
                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
                } else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            case .location:
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            }
            return cell
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.clearCellData()
            cell.profilePic.sd_setShowActivityIndicatorView(true)
            cell.profilePic.sd_setIndicatorStyle(.whiteLarge)
            let userPic1 = self.currentUser?.user_pics[0] ?? ""
            cell.profilePic.sd_setImage(with: URL(string: userPic1), placeholderImage: UIImage(named: "profile_icon"))
            switch self.items[indexPath.row].type {
            case .text:
                cell.message.text = (self.items[indexPath.row].content as! String)
            case .photo:
                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
                } else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            case .location:
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputTextField.resignFirstResponder()
//        switch self.items[indexPath.row].type {
//        case .photo:
//            if let photo = self.items[indexPath.row].image {
//                let info = ["viewType" : ShowExtraView.preview, "pic": photo] as [String : Any]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
//                self.inputAccessoryView?.isHidden = true
//            }
//        case .location:
//            let coordinates = (self.items[indexPath.row].content as! String).components(separatedBy: ":")
//            let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(coordinates[0])!, longitude: CLLocationDegrees(coordinates[1])!)
//            let info = ["viewType" : ShowExtraView.map, "location": location] as [String : Any]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
//            self.inputAccessoryView?.isHidden = true
//        default: break
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.composeMessage(type: .photo, content: pickedImage)
        } else {
            let pickedImage = info[.originalImage] as! UIImage
            self.composeMessage(type: .photo, content: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.locationManager.stopUpdatingLocation()
//        if let lastLocation = locations.last {
//            if self.canSendLocation {
//                let coordinate = String(lastLocation.coordinate.latitude) + ":" + String(lastLocation.coordinate.longitude)
//                let message = Message.init(type: .location, content: coordinate, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
//                Message.send(message: message, toID: self.currentUser!.uid, completion: {(_) in
//                })
//                self.canSendLocation = false
//            }
//        }
    }
    
    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.showKeyboard(notification:)), name: Notification.Name.UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        Message.markMessagesRead(forUserID: self.currentUser!.uid)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.fetchData()
        self.setProfileView()
        
    }

    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return nil
    }
    
}
