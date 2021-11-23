//
//  SenpaiMECard.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/15/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import UIKit
import MGSwipeCards

struct SenpaiMECardModel {
    let name: String
    let age: Int
    var image: String
    let distance: Int
    let watching: String
    let mangas: String
    let cosplay: String
    let attending: String
    let about: String
    let user: User
}

class SenpaiMECard: MGSwipeCard {
    
    override var isFooterTransparent: Bool { return true }
    override var footerHeight: CGFloat { return 420 }
    override var swipeDirections: [SwipeDirection] { return [.left, .right] }
    
    var model: SenpaiMECardModel?

    override func contentView() -> UIView? {
        return SenpaiMECardContentView(images: (model?.user.user_pics)!, first_name: (model?.user.first_name)!)
    }

    override func footerView() -> UIView? {
        return SenpaiMECardFooterView(name: model?.name ?? "", age: "\(model?.age ?? 0)", distance: "\(model?.distance ?? 0)", watching: model?.watching ?? "", mangas: model?.mangas ?? "", cosplay: model?.cosplay ?? "", attending: model?.attending ?? "", about: model?.about ?? "")
    }

    override func overlay(forDirection direction: SwipeDirection) -> UIView? {
        switch direction {
        case .left:
            let leftView = UIView()
            let leftOverlay = SenpaiMECardOverlay(title: "NOPE", color: .passBtnColor, rotationAngle: CGFloat.pi/10)
            leftView.addSubview(leftOverlay)
            leftOverlay.anchor(top: leftView.topAnchor, left: nil, bottom: nil, right: leftView.rightAnchor, paddingTop: 30, paddingRight: 14)
            return leftView
        case .up:
            let upView = UIView()
            let upOverlay = SenpaiMECardOverlay(title: "LOVE", color: .sampleBlue, rotationAngle: -CGFloat.pi/20)
            upView.addSubview(upOverlay)
            upOverlay.anchor(top: nil, left: nil, bottom: upView.bottomAnchor, right: nil, paddingBottom: 20)
            upOverlay.centerXAnchor.constraint(equalTo: upView.centerXAnchor).isActive = true
            return upView
        case .right:
            let rightView = UIView()
            let rightOverlay = SenpaiMECardOverlay(title: "LIKE", color: .likeBtnColor, rotationAngle: -CGFloat.pi/10)
            rightView.addSubview(rightOverlay)
            rightOverlay.anchor(top: rightView.topAnchor, left: rightView.leftAnchor, bottom: nil, right: nil, paddingTop: 26, paddingLeft: 14)
            return rightView
        case .down:
            return nil
        }
    }
    
//    override func didTap(on view: DraggableSwipeView) {
//        let loc = view.tapGestureRecognizer.location(in: self)
//
//        print("---", loc)
//    }
}








class SenpaiMECardContentView: UIView {
    let backgroundView: UIView = {
        let background = UIView()
        background.clipsToBounds = true
        background.layer.cornerRadius = 10
        return background
    }()

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("···", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = customFont.AvenirBlack50
        return btn
    }()

    let pageCtrl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        pc.currentPageIndicatorTintColor = RedColor0
        pc.hidesForSinglePage = true
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    var images = [String]()
    var image_Index = 0
    var gradientLayer: CAGradientLayer?
    var first_name = String()
    
    init(images: [String], first_name: String) {
        super.init(frame: .zero)
        self.first_name = first_name
        self.images.removeAll()
        for image in images {
            if image != "" {
                let tmp_imgView = UIImageView()
                tmp_imgView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "edit_pic_placeholder"))
                self.images.append(image)
            }
        }
        
        if self.images.count == 0 {
            self.images.append("")
        }
        pageCtrl.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        pageCtrl.numberOfPages = self.images.count
        
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.gray)
        imageView.sd_setImage(with: URL(string: images[image_Index]), placeholderImage: UIImage(named: "edit_pic_placeholder"))
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        
        addSubview(backgroundView)
        backgroundView.anchorToSuperview()
        
        backgroundView.addSubview(imageView)
        imageView.anchorToSuperview()
        setTapGesture()
        
        button.addTarget(self, action: #selector(handleRepot(_:)), for: .touchUpInside)
        addSubview(button)
        button.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingLeft: 10, paddingRight: 10, width: 60, height: 50)
        
        addSubview(pageCtrl)
        pageCtrl.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 140, paddingRight: 30, width: 150, height: 50)
        
        configureShadow()
        
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDidTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tap)
        
    }
    
    @objc func handleRepot(_ sender: UIButton) {
        let vc = UIApplication.shared.delegate as! AppDelegate
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report", style: .default , handler:{ (UIAlertAction)in
            
        }))
        
//        alert.addAction(UIAlertAction(title: "Share Profile", style: .default , handler:{ (UIAlertAction)in
//            let text = "What do you think about \(self.first_name)?\n\n\(self.images[0])"
//            let textShare = [ text ]
//            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = vc.window?.rootViewController!.view
//            vc.window?.rootViewController!.present(activityViewController, animated: true, completion: nil)
//        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            
        }))
        
        
        vc.window?.rootViewController!.present(alert, animated: true, completion: {
            
        })
        
        
        
        
    }
    
    @objc func handleDidTap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: imageView)
        if location.x < bounds.width / 2 { // Left
            if image_Index > 0 {
                image_Index = image_Index - 1
            }else {
                image_Index = 0
            }
            imageView.sd_setImage(with: URL(string: images[image_Index]), placeholderImage: UIImage(named: "edit_pic_placeholder"))
        }else { // Right
            if image_Index < self.images.count - 1 {
                image_Index = image_Index + 1
            }else {
                image_Index = self.images.count - 1
            }
            imageView.sd_setImage(with: URL(string: images[image_Index]), placeholderImage: UIImage(named: "edit_pic_placeholder"))
        }
        pageCtrl.currentPage = image_Index
    }

    private func configureShadow() {
        layer.shadowRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradientLayer()
    }

    private func configureGradientLayer() {
        let heightFactor: CGFloat = 0.35
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = CGRect(x: 0, y: (1 - heightFactor) * bounds.height, width: bounds.width, height: heightFactor * bounds.height)
        gradientLayer?.colors = [UIColor.black.withAlphaComponent(0.01).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundView.layer.insertSublayer(gradientLayer!, above: imageView.layer)
    }
}






class SenpaiMECardOverlay: UIView {
    private var title: String?
    private var color: UIColor?
    private var rotationAngle: CGFloat = 0
    
    init(title: String?, color: UIColor?, rotationAngle: CGFloat) {
        super.init(frame: CGRect.zero)
        self.title = title
        self.color = color
        self.rotationAngle = rotationAngle
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        layer.borderColor = color?.cgColor
        layer.borderWidth = 0
        layer.cornerRadius = 40
        clipsToBounds = true
        initializeLabel()
        transform = CGAffineTransform(rotationAngle: rotationAngle)
    }

    private func initializeLabel() {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.attributedText = NSAttributedString(string: title ?? "", attributes: NSAttributedString.Key.overlayAttributes)
//        label.textColor = color
//
//        addSubview(label)
//        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 3, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        
        let img = UIImageView()
        if title == "NOPE" {
            img.image = UIImage(named: "btn_mark_pass")
            
        }else if title == "LIKE" {
            img.image = UIImage(named: "btn_mark_like")
        }
        img.backgroundColor = color
        img.layer.cornerRadius = 40
        img.clipsToBounds = true
        addSubview(img)
        
        img.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, width: 80, height: 80)
    }

}

class SenpaiMECardFooterView: PassThroughView {
    var name: String?
    var age: String?
    var distance: String?
    
    var watching: String?
    var mangas: String?
    var cosplay: String?
    var attending: String?
    var about: String?
    
    
    var view_InfoContainer = UIView()
    var lbl_Name = UILabel()
    var btn_Show = UIButton()
    var lbl_Distance = UILabel()
    
    var lbl_Line = UILabel()
    
    var lbl_WatchingTitle = UILabel()
    var lbl_MangasTitle = UILabel()
    var lbl_CosplayTitle = UILabel()
    var lbl_AttendingTitle = UILabel()
    var lbl_AboutTitle = UILabel()
    
    var lbl_Watching = UILabel()
    var lbl_Mangas = UILabel()
    var lbl_Cosplay = UILabel()
    var lbl_Attending = UILabel()
    var lbl_About = UILabel()
    
    var lblY:CGFloat = 0.0
    var totalH: CGFloat = 0.0
    var isInfoShow = false
    var isFirst = true
    
    private var gradientLayer: CAGradientLayer?
    
    init(name: String?, age: String?, distance: String?, watching: String?, mangas: String?, cosplay: String?, attending: String?, about: String?) {
        super.init(frame: CGRect.zero)
        
        self.name = name
        self.age = age
        self.distance = distance
        self.watching = watching
        self.mangas = mangas
        self.cosplay = cosplay
        self.attending = attending
        self.about = about
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        
        backgroundColor = .clear
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10 //only modify bottom corners
        clipsToBounds = true
        initializeView()
    }

    private func initializeView() {
        view_InfoContainer.backgroundColor = .white
        view_InfoContainer.layer.cornerRadius = 10
        view_InfoContainer.layer.masksToBounds = true
        view_InfoContainer.alpha = 1.0
        addSubview(view_InfoContainer)
        
        let attributedName = NSMutableAttributedString(string: (name ?? "") + ", " + (age ?? ""), attributes: NSAttributedString.Key.titleAttributes)
        lbl_Name.attributedText = attributedName
        view_InfoContainer.addSubview(lbl_Name)
        
        let attributedDistance = NSMutableAttributedString(string: (distance ?? "") + " mi", attributes: NSAttributedString.Key.titleAttributes)
        lbl_Distance.attributedText = attributedDistance
        lbl_Distance.textAlignment = .right
        lbl_Distance.adjustsFontSizeToFitWidth = true
        lbl_Distance.minimumScaleFactor = 0.5
        view_InfoContainer.addSubview(lbl_Distance)
        
        btn_Show.setImage(UIImage(named: "btn_InfoShow"), for: .normal)
        btn_Show.addTarget(self, action: #selector(showProfileInfo), for: .touchUpInside)
        view_InfoContainer.addSubview(btn_Show)
        
        lbl_Line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view_InfoContainer.addSubview(lbl_Line)
        
        let attributedWatchingTitle = NSMutableAttributedString(string: "Anime Currently Watching", attributes: NSAttributedString.Key.subtitleAttributes)
        lbl_WatchingTitle.attributedText = attributedWatchingTitle
        view_InfoContainer.addSubview(lbl_WatchingTitle)
        
        let attributedWatching = NSMutableAttributedString(string: (watching ?? "") + "\n", attributes: NSAttributedString.Key.subcontentAttributes)
        lbl_Watching.attributedText = attributedWatching
        lbl_Watching.numberOfLines = 20
        view_InfoContainer.addSubview(lbl_Watching)
        
        let attributedMangasTitle = NSMutableAttributedString(string: "Favorite Animes & Mangas", attributes: NSAttributedString.Key.subtitleAttributes)
        lbl_MangasTitle.attributedText = attributedMangasTitle
        view_InfoContainer.addSubview(lbl_MangasTitle)
        
        let attributedMangas = NSMutableAttributedString(string: (mangas ?? "") + "\n", attributes: NSAttributedString.Key.subcontentAttributes)
        lbl_Mangas.attributedText = attributedMangas
        lbl_Mangas.numberOfLines = 20
        view_InfoContainer.addSubview(lbl_Mangas)
        
        let attributedCosplayTitle = NSMutableAttributedString(string: "Favorite Character to COSPLAY", attributes: NSAttributedString.Key.subtitleAttributes)
        lbl_CosplayTitle.attributedText = attributedCosplayTitle
        view_InfoContainer.addSubview(lbl_CosplayTitle)
        
        let attributedCosplay = NSMutableAttributedString(string: (cosplay ?? "") + "\n", attributes: NSAttributedString.Key.subcontentAttributes)
        lbl_Cosplay.attributedText = attributedCosplay
        lbl_Cosplay.numberOfLines = 20
        view_InfoContainer.addSubview(lbl_Cosplay)
        
        let attributedAttendingTitle = NSMutableAttributedString(string: "Attending an Upcoming Anime Expo/Con?", attributes: NSAttributedString.Key.subtitleAttributes)
        lbl_AttendingTitle.attributedText = attributedAttendingTitle
        view_InfoContainer.addSubview(lbl_AttendingTitle)
        
        let attributedAttending = NSMutableAttributedString(string: (attending ?? "") + "\n", attributes: NSAttributedString.Key.subcontentAttributes)
        lbl_Attending.attributedText = attributedAttending
        lbl_Attending.numberOfLines = 20
        view_InfoContainer.addSubview(lbl_Attending)
        
        let attributedAboutTitle = NSMutableAttributedString(string: "About Me", attributes: NSAttributedString.Key.subtitleAttributes)
        lbl_AboutTitle.attributedText = attributedAboutTitle
        view_InfoContainer.addSubview(lbl_AboutTitle)
        
        let attributedAbout = NSMutableAttributedString(string: (about ?? "") + "\n", attributes: NSAttributedString.Key.subcontentAttributes)
        lbl_About.attributedText = attributedAbout
        lbl_About.numberOfLines = 20
        view_InfoContainer.addSubview(lbl_About)
    }
    
    @objc func showProfileInfo() {
        if isInfoShow == false {
            isInfoShow = true
            view_InfoContainer.alpha = 1.0
            btn_Show.setImage(UIImage(named: "btn_InfoHide"), for: .normal)
            self.layoutSubviews()
        }else {
            isInfoShow = false
            view_InfoContainer.alpha = 1.0
            btn_Show.setImage(UIImage(named: "btn_InfoShow"), for: .normal)
            self.layoutSubviews()
        }
//        if self.frame.height > 150 {
//            UIView.animate(withDuration: 0.1, animations: {
//                self.frame.origin.y += 200
//                self.frame.size.height -= 200
//            }, completion: nil)

//        }else {
//            UIView.animate(withDuration: 0.1, animations: {
//                self.frame.origin.y -= 200
//                self.frame.size.height += 200
//            }, completion: nil)
//        }
        
        
        
    }
    
    override func layoutSubviews() {
        let padding: CGFloat = 20
        let subPadding: CGFloat = 12
//        var lblY: CGFloat = 0
        if isInfoShow == false {
            if isFirst == true {
                view_InfoContainer.frame = CGRect(x: padding, y: 270, width: bounds.width - 2 * padding, height: 150 - subPadding)
                isFirst = false
            }else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view_InfoContainer.frame = CGRect(x: padding, y: 270, width: self.bounds.width - 2 * padding, height: 150 - subPadding)
                }, completion: nil)
            }
            
            
        }else {
            UIView.animate(withDuration: 0.2, animations: {
                self.view_InfoContainer.frame = CGRect(x: padding, y: 0, width: self.bounds.width - 2 * padding, height: 420 - subPadding)
            }, completion: nil)
        }
//        view_InfoContainer.frame = CGRect(x: padding, y: lblY, width: bounds.width - 2 * padding, height: bounds.height - subPadding)
//        var lblY: CGFloat = 0
        lblY = 0
        btn_Show.frame = CGRect(x: bounds.width / 2 - 40, y: lblY, width: 40, height: 40)
        lblY = lblY + 12
        lbl_Name.frame = CGRect(x: subPadding, y: lblY, width: bounds.width / 2 - 2 * padding, height: 25)
        
        lbl_Distance.frame = CGRect(x: bounds.width - 2 * padding - 60, y: lblY, width: 50, height: 25)
        
        lblY = lblY + 31
        
        lbl_Line.frame = CGRect(x: subPadding, y: lblY, width: bounds.width - 2 * padding - 2 * subPadding, height: 1)
        
        lblY = lblY + 7
        let lblW = bounds.width - 2 * padding - 2 * subPadding
        
        lbl_WatchingTitle.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: 20)
        lblY = lblY + 20
        var infoH1 = heightForView(text: lbl_Watching.text!, font: customFont.AvenirMedium12!, width: lblW - 10)
        lbl_Watching.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: infoH1)
        if infoH1 < 20 {
            infoH1 = 20
        }
        lblY = lblY + infoH1
        
        lbl_MangasTitle.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: 20)
        lblY = lblY + 20
        var infoH2 = heightForView(text: lbl_Mangas.text!, font: customFont.AvenirMedium12!, width: lblW - 10)
        lbl_Mangas.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: infoH2)
        if infoH2 < 20 {
            infoH2 = 20
        }
        lblY = lblY + infoH2
        
        lbl_CosplayTitle.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: 20)
        lblY = lblY + 20
        var infoH3 = heightForView(text: lbl_Cosplay.text!, font: customFont.AvenirMedium12!, width: lblW - 10)
        lbl_Cosplay.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: infoH3)
        if infoH3 < 20 {
            infoH3 = 20
        }
        lblY = lblY + infoH3
        
        lbl_AttendingTitle.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: 20)
        lblY = lblY + 20
        var infoH4 = heightForView(text: lbl_Attending.text!, font: customFont.AvenirMedium12!, width: lblW - 10)
        lbl_Attending.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: infoH4)
        if infoH4 < 20 {
            infoH4 = 20
        }
        lblY = lblY + infoH4
        
        lbl_AboutTitle.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: 20)
        lblY = lblY + 20
        var infoH5 = heightForView(text: lbl_About.text!, font: customFont.AvenirMedium12!, width: lblW - 10)
        lbl_About.frame = CGRect(x: subPadding, y: lblY, width: lblW, height: infoH5)
        if infoH5 < 20 {
            infoH5 = 20
        }
        lblY = lblY + infoH5
        totalH = lblY + 10
    }
    
}

class PassThroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}

extension NSAttributedString.Key {

    static var overlayAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 42)!,
        NSAttributedString.Key.kern: 5.0
    ]

    static var shadowAttribute: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.2)
        return shadow
    }()

    static var titleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: customFont.AvenirMedium16!,
        NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8),
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]

    static var subtitleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: customFont.AvenirMedium13!,
        NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7),
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
    
    static var subcontentAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: customFont.AvenirMedium12!,
        NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5),
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
}


