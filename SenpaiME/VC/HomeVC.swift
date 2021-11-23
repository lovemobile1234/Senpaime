//
//  HomeVC.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/11/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import MGSwipeCards
import PopBounceButton
import AudioToolbox
import FacebookShare

class HomeVC: UIViewController {
    
    @IBOutlet weak var navbtn_Profile: UIButton!
    @IBOutlet weak var navbtn_Center: UIButton!
    @IBOutlet weak var navbtn_Chat: UIButton!
    
    @IBOutlet weak var scr_Container: UIScrollView!
    @IBOutlet weak var view_Profile: UIView!
    @IBOutlet weak var view_Home: UIView!
    @IBOutlet weak var view_SearchAnimation: UIView!
    @IBOutlet weak var view_Chat: UIView!
    
    @IBOutlet weak var tbl_Matches: UITableView!
    @IBOutlet weak var tbl_Messages: UITableView!
    
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
    
    @IBOutlet weak var constraint_ContainerW: NSLayoutConstraint!
    
    
    @IBOutlet weak var view_Pop: UIView!
    @IBOutlet weak var view_Pop_Sub: UIView!
    @IBOutlet weak var img_Pop_ProfilePic: UIImageView!
    @IBOutlet weak var lbl_Pop_Name: UILabel!
    @IBOutlet weak var btn_Pop_Message: UIButton!
    @IBOutlet weak var btn_Pop_FB: UIButton!
    @IBOutlet weak var btn_Pop_TW: UIButton!
    @IBOutlet weak var btn_Pop_Rate: UIButton!
    @IBOutlet weak var btn_Pop_Exit: UIButton!

    var matchItems = [Match]()
    var messageItems = [Match]()
    
    var matchPopItems = [Match]()
    var is_PopShow = false
//    var chat_MatchesArr = [[String : Any]]()
//    var chat_MessagesArr = [[String : Any]]()
  
    let cardStack = MGCardStackView()
    
    var backgroundGradient: UIView?
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()
    
    let undoButton: PopBounceButton = {
        let button = PopBounceButton()
        button.setImage(UIImage(named: ""))
        button.tag = 1
        return button
    }()
    
    let passButton: PopBounceButton = {
        let button = PopBounceButton()
        button.backgroundColor = .passBtnColor
        button.setImage(UIImage(named: "btn_mark_pass"))
        button.tag = 2
        return button
    }()
    
//    let superLikeButton: PopBounceButton = {
//        let button = PopBounceButton()
//        button.setImage(UIImage(named: "star"))
//        button.tag = 3
//        return button
//    }()
    
    let likeButton: PopBounceButton = {
        let button = PopBounceButton()
        button.backgroundColor = .likeBtnColor
        button.setImage(UIImage(named: "btn_mark_like"))
        button.tag = 4
        return button
    }()
    
    let boostButton: PopBounceButton = {
        let button = PopBounceButton()
        button.setImage(UIImage(named: ""))
        button.tag = 5
        return button
    }()
    
    var cardModels: [SenpaiMECardModel] = []
    
    var isDidLoad = true
    
    var databaseRef = DatabaseReference()
    var userDic:User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view_Pop.isHidden = true
        
        databaseRef = Database.database().reference()
        constraint_ContainerW.constant = self.view.bounds.size.width * 3
        
        self.fetchData()
        self.fetchMatchPopData()
        self.scr_Container.isHidden = true
        self.onLoadViews()
        
        self.initializeCardStackView()
        self.initializeButtonStackView()
        self.setupButtons()
        view_SearchAnimation.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: StaticDATA.currentUser) != nil {
            let decoded  = userDefaults.object(forKey: StaticDATA.currentUser) as! Data
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
            self.userDic = decodedUser
            self.setUserProfileView()
        }
        self.loadFilterUsers()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isDidLoad == true {
            self.scr_Container.contentOffset.x = self.view.bounds.size.width
            self.scr_Container.isHidden = false
            isDidLoad = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.removeSearchAnimationView()
    }
    
    override func viewDidLayoutSubviews() {
        for button in buttonStackView.subviews as! [PopBounceButton] {
            let diameter = button.bounds.width
            button.layer.cornerRadius = diameter / 2
            button.setShadow(radius: 0.2 * diameter, opacity: 0.05, offset: CGSize(width: 0, height: 0.15 * diameter))
        }
//        configureBackgroundGradient()
    }
    
    func onLoadViews() {
        
        
//        chat_MatchesArr.append(["pic":"chatprofile1.png", "name":"Sam", "isred":"1"])
//        chat_MatchesArr.append(["pic":"chatprofile2.png", "name":"Judy", "isred":"1"])
//        chat_MatchesArr.append(["pic":"chatprofile3.png", "name":"Bret", "isred":"0"])
//
//        chat_MessagesArr.append(["pic":"chatprofile1.png", "name":"Sam", "last_msg":"Hi, How are you doing?", "isred":"1"])
//        chat_MessagesArr.append(["pic":"chatprofile3.png", "name":"Bret", "last_msg":"Did you still want lunch?", "isred":"0"])
    }
    
    private func setV(view:UIView) {
        view.frame = CGRect(x: self.view.bounds.width/2-40, y: self.view.bounds.height/2-120,width:80,height:80)
        view.layer.cornerRadius = 40
    }
    
    @IBAction func onActionNavProfile(_ sender: Any) {
        self.scrollToPage(page: 0, animated: true)
    }
    
    @IBAction func onActionNavCenter(_ sender: Any) {
        self.scrollToPage(page: 1, animated: true)
    }
    
    @IBAction func onActionNavChat(_ sender: Any) {
        self.scrollToPage(page: 2, animated: true)
    }
    
    
    
}

// MARK: Pop View
extension HomeVC {
    
    func fetchMatchPopData() {
        Match.showPopMatches { (matches) in
            if self.is_PopShow == false {
                self.is_PopShow = true
                self.matchPopItems = matches
                let match = self.matchPopItems.last
                DispatchQueue.main.async {
                    self.setPopViewData(matchItem: match!)
                }
            }
        }
    }
    
    func setPopViewData(matchItem : Match) {
        
        self.lbl_Pop_Name.text = matchItem.user.first_name + ", " + matchItem.user.age
        let userPics = matchItem.user.user_pics
        if userPics.count > 0 {
            let userPic1 = userPics[0]
            self.img_Pop_ProfilePic.sd_setShowActivityIndicatorView(true)
            self.img_Pop_ProfilePic.sd_setIndicatorStyle(.whiteLarge)
            self.img_Pop_ProfilePic.sd_setImage(with: URL(string: userPic1), placeholderImage: UIImage(named: "profile_icon"))
        }
        Match.addIsPopShow(forUserID: matchItem.user.uid) { (complete) in
            
        }
        self.showPopMatchView()
    }
    
    
    func showPopMatchView() {
        
        self.view_Pop.isHidden = true
        self.view_Pop.alpha = 0.0
        self.view_Pop?.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        UIView.animate(withDuration: 0.15, animations: {
            self.view_Pop.alpha = 1.0
            self.view_Pop?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.view_Pop.isHidden = false
        }, completion: { (finished: Bool) in
            self.view_Pop?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            UIView.animate(withDuration: 0.08, animations: {
                self.view_Pop?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
    
    
    @IBAction func onActionPopMessage(_ sender: Any) {
        AppManager.shared.showLoadingIndicator(view: self.view)
        User.addChatUser(forUserID: self.matchPopItems.last!.user.uid, completion: { (complete) in
            AppManager.shared.hideLoadingIndicator()
            if complete == true {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                VC.currentUser = self.matchPopItems.last?.user
                self.navigationController?.pushViewController(VC, animated: true)
            }else {
                AppManager.shared.showAlert(msg: "Failed. Please try again later.", activity: self)
            }
        })
    }
    
    @IBAction func onActionPopFB(_ sender: Any) {
        let text = "Hey, check out this app I'm using called SenpaiME! It's awesome!\n"
        let content:LinkShareContent = LinkShareContent.init(url: URL.init(string: "https://itunes.apple.com/us/app/tinder/id547702041?mt=8")!, quote: text)
        
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
        }
        do
        {
            try shareDialog.show()
        }
        catch
        {
            print("Exception")
            
        }
    }
    
    @IBAction func onActionPopTW(_ sender: Any) {
        let tweetText = "Hey, check out this app I'm using called SenpaiME! It's awesome!"
        let tweetUrl = "https://itunes.apple.com/us/app/tinder/id547702041?mt=8"
        
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // open in safari
        guard let url = URL(string: escapedShareString) else {
            return
        }
        guard #available(iOS 10, *) else {
            UIApplication.shared.openURL(url)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func onActionPopRate(_ sender: Any) {
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
    
    @IBAction func onActionPopExit(_ sender: Any) {
        self.is_PopShow = false
        self.view_Pop.isHidden = true
    }
    
}

// MARK: Profile View
extension HomeVC {
    
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
    
    @IBAction func onActionSettings(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func onActionEditInfo(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "EditInfoVC") as! EditInfoVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

// MARK: Swipe View
extension HomeVC {
    
    func loadFilterUsers() {
        self.searchAnimation()
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: StaticDATA.currentUser) != nil {
            let decoded  = userDefaults.object(forKey: StaticDATA.currentUser) as! Data
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
            
            let my_coordinate = CLLocation(latitude: Double(decodedUser.coor_lat)!, longitude: Double(decodedUser.coor_lng)!)
            
            self.cardModels.removeAll()
            self.cardStack.reloadData()
            User.downloadFilterUsers(exceptID: Auth.auth().currentUser!.uid) { (User) in
                
                let their_Coordinate = CLLocation(latitude: Double(User.coor_lat)!, longitude: Double(User.coor_lng)!)
                let radiusInMetter = my_coordinate.distance(from: their_Coordinate)
                
                let picURL = User.user_pics[0]
                self.cardModels.append(SenpaiMECardModel(name: User.first_name, age: Int(User.age)!, image: picURL, distance: Int(round(radiusInMetter/1609.344)), watching: User.watching, mangas: User.mangas, cosplay: User.cosplay, attending: User.attending, about: User.about, user: User))
                self.removeSearchAnimationView()
                self.cardStack.reloadData()
            }
        }
    }
    
    func searchAnimation() {
        
        let circleArray = [UIView(), UIView(), UIView(), UIView()]
        let bleColor = UIColor.rbg(r: 255, g: 84, b: 92)
        let scale = CGFloat(circleArray.count + 1)
        let duration = TimeInterval(circleArray.count)
        var delay = 0.0
        for circle in circleArray {
            setV(view: circle)
            circle.backgroundColor = bleColor
            self.view_SearchAnimation.addSubview(circle)
            
            UIView.animate(withDuration: duration, delay: delay, options: .repeat, animations: { () -> Void in
                circle.transform = CGAffineTransform.init(scaleX: scale, y: scale)
                circle.alpha = 0.0
            }, completion: nil)
            delay += 1.0
        }
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: StaticDATA.currentUser) != nil {
            let decoded  = userDefaults.object(forKey: StaticDATA.currentUser) as! Data
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
            
            let userPics = decodedUser.user_pics
            if userPics.count > 0 {
                let userPic1 = userPics[0]
                let bleImageView:UIImageView = UIImageView()
                bleImageView.sd_setShowActivityIndicatorView(true)
                bleImageView.sd_setIndicatorStyle(.whiteLarge)
                bleImageView.sd_setImage(with: URL(string: userPic1), placeholderImage: UIImage(named: "profile_icon"))
                bleImageView.frame = CGRect(x: self.view.bounds.width/2-40, y: self.view.bounds.height/2-120,width:80,height:80)
                bleImageView.layer.cornerRadius = 40
                bleImageView.clipsToBounds = true
                self.view_SearchAnimation.addSubview(bleImageView)
            }
        }
    }
    
    func removeSearchAnimationView() {
        for v in view_SearchAnimation.subviews {
            v.removeFromSuperview()
        }
    }
    
    func initializeButtonStackView() {
//        let largeMultiplier: CGFloat = 88/414//66/414 //based on width of iPhone 8+
        
        view_Home.addSubview(buttonStackView)
        buttonStackView.anchor(top: nil, left: view_Home.safeAreaLayoutGuide.leftAnchor, bottom: view_Home.safeAreaLayoutGuide.bottomAnchor, right: view_Home.safeAreaLayoutGuide.rightAnchor, paddingLeft: 24, paddingBottom: 12, paddingRight: 24)
        
//        buttonStackView.frame = CGRect(x: view_Home.bounds.width/2-view_Home.bounds.width*largeMultiplier, y: view_Home.bounds.height-view_Home.bounds.width*largeMultiplier, width: view_Home.bounds.width*largeMultiplier*2, height: view_Home.bounds.width*largeMultiplier)
        
        undoButton.alpha = 0
        boostButton.alpha = 0
        buttonStackView.addArrangedSubview(undoButton)
        buttonStackView.addArrangedSubview(passButton)
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(boostButton)
    }
    
    func setupButtons() {
        let largeMultiplier: CGFloat = 88/414//66/414 //based on width of iPhone 8+
        let smallMultiplier: CGFloat = 54/414//54/414 //based on width of iPhone 8+
        configureButton(button: undoButton, diameterMultiplier: smallMultiplier)
        configureButton(button: passButton, diameterMultiplier: largeMultiplier)
        configureButton(button: likeButton, diameterMultiplier: largeMultiplier)
        configureButton(button: boostButton, diameterMultiplier: smallMultiplier)
    }
    
    func configureButton(button: PopBounceButton, diameterMultiplier: CGFloat) {
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(lessThanOrEqualTo: view_Home.widthAnchor, multiplier: diameterMultiplier).isActive = true
        button.widthAnchor.constraint(lessThanOrEqualTo: view_Home.heightAnchor, multiplier: diameterMultiplier).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
    }
    
    func initializeCardStackView() {
        view_Home.addSubview(cardStack)
//        cardStack.anchor(top: view_Home.safeAreaLayoutGuide.topAnchor, left: view_Home.safeAreaLayoutGuide.leftAnchor, bottom: view_Home.safeAreaLayoutGuide.bottomAnchor, right: view_Home.safeAreaLayoutGuide.rightAnchor)
        cardStack.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height*0.8)
        cardStack.delegate = self
        cardStack.dataSource = self
    }
    
    func configureBackgroundGradient() {
        backgroundGradient?.removeFromSuperview()
        backgroundGradient = UIView()
        view_Home.insertSubview(backgroundGradient!, at: 0)
        backgroundGradient?.frame = CGRect(origin: .zero, size: view_Home.bounds.size)
        
        let myGrey = UIColor(red: 244/255, green: 247/255, blue: 250/255, alpha: 1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, myGrey.cgColor]
        gradientLayer.frame = backgroundGradient!.frame
        backgroundGradient?.layer.addSublayer(gradientLayer)
    }
    
    @objc func handleTap(_ sender: PopBounceButton) {
        switch sender.tag {
        case 1:
            cardStack.undoLastSwipe()
        case 2:
            cardStack.swipe(.left)
        case 3:
            cardStack.swipe(.up)
        case 4:
            cardStack.swipe(.right)
        default:
            break
        }
    }
}

//MARK: - Chat List View
extension HomeVC {
    //Downloads conversations
    func fetchData() {
        Match.showMatches { (matches) in
            self.matchItems = matches
            self.messageItems.removeAll()
            for match in self.matchItems {
                if match.isChat == true {
                    self.messageItems.append(match)
                }
            }
            
            DispatchQueue.main.async {
                self.tbl_Matches.reloadData()
                self.tbl_Messages.reloadData()
            }
        }
    }
    
    func playSound() {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "newMessage", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
}

//MARK: - MGCardStackView Data Source

extension HomeVC: MGCardStackViewDataSource {
    
    func cardStack(_ cardStack: MGCardStackView, cardForIndexAt index: Int) -> MGSwipeCard {
        let card = SenpaiMECard()
        card.model = cardModels[index]
        return card
    }
    
    func numberOfCards(in cardStack: MGCardStackView) -> Int {
        return cardModels.count
    }
}

//MARK: - MGCardStackView Delegate

extension HomeVC: MGCardStackViewDelegate {
    
    func didSwipeAllCards(_ cardStack: MGCardStackView) {
        print("Swiped all cards!")
        self.loadFilterUsers()
    }
    
    func cardStack(_ cardStack: MGCardStackView, didUndoCardAt index: Int, from direction: SwipeDirection) {
        print("Undo \(direction) swipe on \(cardModels[index].name)")
    }
    
    func cardStack(_ cardStack: MGCardStackView, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("Swiped \(direction) on \(cardModels[index].name)")
        if direction == .right {
            self.swipeLike(index: index)
        }else {
            self.swipeUnlike(index: index)
        }
    }
    
    func swipeLike(index : Int) {
        User.likeUser(forUserID: cardModels[index].user.uid) { (complete) in
            
        }
    }
    
    func swipeUnlike(index : Int) {
        User.unlikeUser(forUserID: cardModels[index].user.uid) { (complete) in
            
        }
    }
    
    func cardStack(_ cardStack: MGCardStackView, didSelectCardAt index: Int, tapCorner: UIRectCorner) {
        var cornerString: String
        switch tapCorner {
        case .topLeft:
            cornerString = "top left"
        case .topRight:
            cornerString = "top right"
            self.cardModels[index].image = self.cardModels[index].user.user_pics[1]
//            self.cardStack.layoutSubviews()
        //            self.cardModels.append(SenpaiMECardModel(name: User.first_name, age: Int(User.age)!, image: picURL, distance: Int(round(radiusInMetter/1609.344)), watching: User.watching, mangas: User.mangas, cosplay: User.cosplay, attending: User.attending, about: User.about, user: User))
//            cardStack.reloadData()
            
            self.cardStack.layoutSubviews()
//            cardStack.layoutSubviews()
//            car
        case .bottomRight:
            cornerString = "bottom right"
        case .bottomLeft:
            cornerString = "bottom left"
        default:
            cornerString = ""
        }
        print("Card tapped at \(cornerString)")
    }
}

// MARK: ChatList
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_Matches {
            return matchItems.count
        }else {
            return messageItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = self.view.bounds.size.width * 0.3
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_Matches {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMatchesCell", for: indexPath) as! ChatMatchesCell
//            let chat_Matches = chat_MatchesArr[indexPath.row]
//            cell.img_ProfilePic.image = UIImage(named: (chat_Matches["pic"] as? String ?? ""))
//            cell.lbl_ProfileName.text = chat_Matches["name"] as? String ?? ""
//            if (chat_Matches["isred"] as? String ?? "0") == "1" {
//                cell.btn_Add.isHidden = false
//            }else {
//                cell.btn_Add.isHidden = true
//            }
//            cell.selectionStyle = .none
//            return cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMatchesCell", for: indexPath) as! ChatMatchesCell
            let chat_Matches = matchItems[indexPath.row]
            
            let userPics = chat_Matches.user.user_pics
            let userPic1 = userPics[0]
            cell.img_ProfilePic.sd_setShowActivityIndicatorView(true)
            cell.img_ProfilePic.sd_setIndicatorStyle(.whiteLarge)
            cell.img_ProfilePic.sd_setImage(with: URL(string: userPic1), placeholderImage: UIImage(named: "profile_icon"))
            
            cell.lbl_ProfileName.text = chat_Matches.user.first_name
            if (chat_Matches.isChat) == false {
                cell.btn_Add.isHidden = false
            }else {
                cell.btn_Add.isHidden = true
            }
            cell.btn_Add.tag = indexPath.row
            cell.btn_Add.addTarget(self, action: #selector(onActionAddChat(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessagesCell", for: indexPath) as! ChatMessagesCell
//            let chat_Messages = chat_MessagesArr[indexPath.row]
//            cell.img_ProfilePic.image = UIImage(named: (chat_Messages["pic"] as? String ?? ""))
//            cell.lbl_ProfileName.text = chat_Messages["name"] as? String ?? ""
//            cell.lbl_LastMsg.text = chat_Messages["last_msg"] as? String ?? ""
//            if (chat_Messages["isred"] as? String ?? "0") == "1" {
//                cell.btn_Add.isHidden = false
//            }else {
//                cell.btn_Add.isHidden = true
//            }
//            cell.selectionStyle = .none
//            return cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessagesCell", for: indexPath) as! ChatMessagesCell
            let chat_Messages = messageItems[indexPath.row]
            
            let userPics = chat_Messages.user.user_pics
            let userPic1 = userPics[0]
            cell.img_ProfilePic.sd_setShowActivityIndicatorView(true)
            cell.img_ProfilePic.sd_setIndicatorStyle(.whiteLarge)
            cell.img_ProfilePic.sd_setImage(with: URL(string: userPic1), placeholderImage: UIImage(named: "profile_icon"))
            
            cell.lbl_ProfileName.text = chat_Messages.user.first_name
            cell.lbl_LastMsg.text = chat_Messages.lastMessage.content as? String ?? ""
//            if (chat_Messages["isred"] as? String ?? "0") == "1" {
//                cell.btn_Add.isHidden = false
//            }else {
                cell.btn_Add.isHidden = true
//            }
            cell.selectionStyle = .none
            return cell
            
        }
    }
    
    @objc func onActionAddChat(_ sender : UIButton) {
        let addUser = matchItems[sender.tag]
        AppManager.shared.showLoadingIndicator(view: self.view)
        User.addChatUser(forUserID: addUser.user.uid, completion: { (complete) in
            AppManager.shared.hideLoadingIndicator()
            if complete == true {
                
            }else {
                AppManager.shared.showAlert(msg: "Failed. Please try again later.", activity: self)
            }
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbl_Matches {
            
            
        }else {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            VC.currentUser = self.messageItems[indexPath.row].user
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}




// MARK: ScrollViewDelegate
extension HomeVC: UIScrollViewDelegate {
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scr_Container.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scr_Container.scrollRectToVisible(frame, animated: animated)
        if page == 0 {
            navbtn_Profile.setImage(UIImage(named: "navbtn_profile_sel"), for: .normal)
            navbtn_Chat.setImage(UIImage(named: "navbtn_chat"), for: .normal)
        }else if page == 1 {
            navbtn_Profile.setImage(UIImage(named: "navbtn_profile"), for: .normal)
            navbtn_Chat.setImage(UIImage(named: "navbtn_chat"), for: .normal)
        }else if page == 2 {
            navbtn_Profile.setImage(UIImage(named: "navbtn_profile"), for: .normal)
            navbtn_Chat.setImage(UIImage(named: "navbtn_chat_sel"), for: .normal)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let curPage = self.scr_Container.currentPage
        if curPage == 0 {
            navbtn_Profile.setImage(UIImage(named: "navbtn_profile_sel"), for: .normal)
            navbtn_Chat.setImage(UIImage(named: "navbtn_chat"), for: .normal)
        }else if curPage == 1 {
            navbtn_Profile.setImage(UIImage(named: "navbtn_profile"), for: .normal)
            navbtn_Chat.setImage(UIImage(named: "navbtn_chat"), for: .normal)
        }else if curPage == 2 {
            navbtn_Profile.setImage(UIImage(named: "navbtn_profile"), for: .normal)
            navbtn_Chat.setImage(UIImage(named: "navbtn_chat_sel"), for: .normal)
        }
    }
    
}

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)
    }
}


