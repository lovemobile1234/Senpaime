//
//  EditInfoVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/14/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EditInfoVC: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var view_PicsView: UIView!
    @IBOutlet weak var img_ProfilePic1: Rounded8ImageView!
    @IBOutlet weak var img_ProfilePic2: Rounded8ImageView!
    @IBOutlet weak var img_ProfilePic3: Rounded8ImageView!
    @IBOutlet weak var img_ProfilePic4: Rounded8ImageView!
    @IBOutlet weak var img_ProfilePic5: Rounded8ImageView!
    
    
    @IBOutlet weak var tv_FirstName: UITextView!
    @IBOutlet weak var tv_Age: UITextView!
    @IBOutlet weak var tv_Gender: UITextView!
    
    @IBOutlet weak var tv_Watching: UITextView!
    @IBOutlet weak var tv_Mangas: UITextView!
    @IBOutlet weak var tv_Cosplay: UITextView!
    @IBOutlet weak var tv_Attending: UITextView!
    @IBOutlet weak var tv_About: UITextView!
    
    @IBOutlet weak var constraint_WatchingH: NSLayoutConstraint!
    @IBOutlet weak var constraint_MangasH: NSLayoutConstraint!
    @IBOutlet weak var constraint_CosplayH: NSLayoutConstraint!
    @IBOutlet weak var constraint_AttendingH: NSLayoutConstraint!
    @IBOutlet weak var constraint_AboutH: NSLayoutConstraint!
    

    var isEditPics = [false, false, false, false, false]
    
    var userPicsArray = ["", "", "", "", ""]
    
    var selectPicNum = 0
    
    var databaseRef = DatabaseReference()
    var userDic:User? = nil
    
    let agePicker = UIPickerView()
    
    let gendersArray = ["Male", "Female"]
    let genderPicker = UIPickerView()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: StaticDATA.currentUser) != nil {
            let decoded  = userDefaults.object(forKey: StaticDATA.currentUser) as! Data
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
            self.userDic = decodedUser
            self.setUserProfileView()
        }
        
        agePicker.delegate = self
        agePicker.dataSource = self
        agePicker.backgroundColor = .white
        self.setAgePicker()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = .white
        self.setGenderPicker()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    func setAgePicker(){
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAgePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        tv_Age.inputAccessoryView = toolbar
        // add datepicker to textField
        tv_Age.inputView = agePicker
    }
    
    @objc func doneAgePicker() {
        let row = agePicker.selectedRow(inComponent: 0)
        tv_Age.text = String(row+18)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func setGenderPicker(){
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneGenderPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        tv_Gender.inputAccessoryView = toolbar
        // add datepicker to textField
        tv_Gender.inputView = genderPicker
    }
    
    @objc func doneGenderPicker(){
        let row = genderPicker.selectedRow(inComponent: 0)
        tv_Gender.text = gendersArray[row]
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func setUserProfileView() {

        let userPics = userDic!.user_pics
        if userPics.count > 0 {
            for index in 0...userPics.count-1 {
                let img_Pic = view_PicsView.viewWithTag(index+10) as! UIImageView
                if !userPics[index].isEmpty {
                    userPicsArray[index] = userPics[index]
                    img_Pic.sd_setShowActivityIndicatorView(true)
                    img_Pic.sd_setIndicatorStyle(.whiteLarge)
                    img_Pic.sd_setImage(with: URL(string: userPics[index]), placeholderImage: UIImage(named: "edit_pic_placeholder"))
                }
            }
        }
        
        let sWidth = self.view.bounds.width - 70
        let tvFont = customFont.AvenirMedium14
        
        tv_FirstName.text = userDic!.first_name
        tv_Age.text = userDic!.age
        tv_Gender.text = userDic!.gender
        
        tv_Watching.text = userDic!.watching
        tv_Mangas.text = userDic!.mangas
        tv_Cosplay.text = userDic!.cosplay
        tv_Attending.text = userDic!.attending
        tv_About.text = userDic!.about
        
        constraint_WatchingH.constant = heightForView(text: tv_Watching.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: tv_Watching.text!, font: tvFont!, width: sWidth) + 20
        constraint_MangasH.constant = heightForView(text: tv_Mangas.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: tv_Mangas.text!, font: tvFont!, width: sWidth) + 20
        constraint_CosplayH.constant = heightForView(text: tv_Cosplay.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: tv_Cosplay.text!, font: tvFont!, width: sWidth) + 20
        constraint_AttendingH.constant = heightForView(text: tv_Attending.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: tv_Attending.text!, font: tvFont!, width: sWidth) + 20
        constraint_AboutH.constant = heightForView(text: tv_About.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: tv_About.text!, font: tvFont!, width: sWidth) + 20
    }
    
    @IBAction func onActionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let sWidth = self.view.bounds.width - 70
        let tvFont = customFont.AvenirMedium14
        if textView == tv_Watching {
            constraint_WatchingH.constant = heightForView(text: textView.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: textView.text!, font: tvFont!, width: sWidth) + 20
        }else if textView == tv_Mangas {
            constraint_MangasH.constant = heightForView(text: textView.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: textView.text!, font: tvFont!, width: sWidth) + 20
        }else if textView == tv_Cosplay {
            constraint_CosplayH.constant = heightForView(text: textView.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: textView.text!, font: tvFont!, width: sWidth) + 20
        }else if textView == tv_Attending {
            constraint_AttendingH.constant = heightForView(text: textView.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: textView.text!, font: tvFont!, width: sWidth) + 20
        }else if textView == tv_About {
            constraint_AboutH.constant = heightForView(text: textView.text!, font: tvFont!, width: sWidth) < 25 ? 25 : heightForView(text: textView.text!, font: tvFont!, width: sWidth) + 20
        }
    }
    
    @IBAction func onActionUpdate(_ sender: Any) {
        
        if tv_FirstName.text.isEmpty {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please enter your first name.", comment: "masss"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }else if tv_Age.text.isEmpty {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please select your age.", comment: "masss"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }else if tv_Gender.text.isEmpty {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please select your gender.", comment: "masss"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "masss"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        AppManager.shared.showLoadingIndicator(view: self.view)
        
        let group = DispatchGroup()
        for index in 0...4 {

            if isEditPics[index] == true {
                group.enter()
                
                let img_Pic = view_PicsView.viewWithTag(index+10) as! UIImageView
                let picture = img_Pic.image
                let imageName:String = String("\(Int64(Date().timeIntervalSince1970))\(index).png")
                
                let storageRef = Storage.storage().reference().child(DatabaseKeys.users).child((Auth.auth().currentUser?.uid)!).child(imageName)
                if let uploadData = picture!.pngData() {

                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                group.leave()
                            }else {
                                storageRef.downloadURL(completion: { (url, error) in
                                    if url == nil {
                                        print(error!)
                                        group.leave()
                                    }else {
                                        self.userPicsArray[index] = (url?.absoluteString) ?? ""
                                        group.leave()
                                    }
                                    
                                    
                                })
                                
                                
                            }
                    })
                }
            }
        }
        
        group.notify(queue: .main) {
            let params = ["first_name": self.tv_FirstName.text,
                          "age": self.tv_Age.text,
                          "gender": self.tv_Gender.text,
                          "user_pics": self.userPicsArray,
                          "watching": self.tv_Watching.text,
                          "mangas": self.tv_Mangas.text,
                          "cosplay": self.tv_Cosplay.text,
                          "attending": self.tv_Attending.text,
                          "about": self.tv_About.text] as [String : Any]
            
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
    
    @IBAction func onActionAddPic1(_ sender: Any) {
        selectPicNum = 1
        openActionSheet()
    }
    
    @IBAction func onActionAddPic2(_ sender: Any) {
        selectPicNum = 2
        openActionSheet()
    }
    
    @IBAction func onActionAddPic3(_ sender: Any) {
        selectPicNum = 3
        openActionSheet()
    }
    
    @IBAction func onActionAddPic4(_ sender: Any) {
        selectPicNum = 4
        openActionSheet()
    }
    
    @IBAction func onActionAddPic5(_ sender: Any) {
        selectPicNum = 5
        openActionSheet()
    }
    
    func openActionSheet() {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Choose image from gallery", style: .default) { action -> Void in
            self.openPhotoLibrary()
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Take new photo from camera", style: .default) { action -> Void in
            self.openCamera()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You can't use the camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}

extension EditInfoVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            if selectPicNum == 1 {
                isEditPics[0] = true
                img_ProfilePic1.image = image
            }else if selectPicNum == 2 {
                isEditPics[1] = true
                img_ProfilePic2.image = image
            }else if selectPicNum == 3 {
                isEditPics[2] = true
                img_ProfilePic3.image = image
            }else if selectPicNum == 4 {
                isEditPics[3] = true
                img_ProfilePic4.image = image
            }else if selectPicNum == 5 {
                isEditPics[4] = true
                img_ProfilePic5.image = image
            }else {
                
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    

    
//    public enum ImageFormat {
//        case png
//        case jpeg(CGFloat)
//    }
    
//    func convertImageTobase64(format: ImageFormat, image:UIImage) -> String? {
//        var imageData: Data?
//
//        switch format {
//        case .png: imageData = UIImagePNGRepresentation(image)
//        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(image, compression)
//        }
//        return imageData?.base64EncodedString(options: .lineLength64Characters)
//    }
//
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}


extension EditInfoVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == agePicker {
            return 43
        }else {
            return gendersArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == agePicker {
            return String(row+18)
        }else {
            return gendersArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == agePicker {
            tv_Age.text = String(row+18)
        }else {
            tv_Gender.text = gendersArray[row]
        }
    }
}
