//
//  Helper.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/9/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import Foundation
import UIKit

struct DatabaseKeys {
    static let users = "users"
    static let matches = "matches"
    static let messages = "messages"
}

struct ScreenSize  {
    static let Width         = UIScreen.main.bounds.size.width
    static let Height        = UIScreen.main.bounds.size.height
    static let Max_Length    = max(ScreenSize.Width, ScreenSize.Height)
    static let Min_Length    = min(ScreenSize.Width, ScreenSize.Height)
}

struct DeviceType {
    static let iPhone4  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length < 568.0
    static let iPhone5_5s  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length == 568.0
    static let iPhone6_6s_7 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length == 667.0
    static let iPhone6P_6sP_7P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length == 736.0
    static let iPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length == 812.0
    static let iPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.Max_Length == 1024.0
}

class StaticDATA: NSObject {
    static let currentUser = "CurrentUser"
    
}

class RoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = 20
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class RoundedRedBorder2ImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.layer.borderColor = RedColor0.cgColor
        self.layer.borderWidth = 2
        self.clipsToBounds = true
    }
}

class Rounded8ImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = 8
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

struct customFont {
    static let AvenirBlack72  = UIFont(name: "Avenir-Black", size: 72.0)
    static let AvenirBlack60  = UIFont(name: "Avenir-Black", size: 60.0)
    static let AvenirBlack50  = UIFont(name: "Avenir-Black", size: 50.0)
    static let AvenirBlack24  = UIFont(name: "Avenir-Black", size: 24.0)
    
    static let AvenirHeavy20  = UIFont(name: "Avenir-Heavy", size: 20.0)
    static let AvenirHeavy19  = UIFont(name: "Avenir-Heavy", size: 19.0)
    static let AvenirHeavy18  = UIFont(name: "Avenir-Heavy", size: 18.0)
    static let AvenirHeavy17  = UIFont(name: "Avenir-Heavy", size: 17.0)
    static let AvenirHeavy16  = UIFont(name: "Avenir-Heavy", size: 16.0)
    static let AvenirHeavy15  = UIFont(name: "Avenir-Heavy", size: 15.0)
    
    static let AvenirMedium20  = UIFont(name: "Avenir-Medium", size: 20.0)
    static let AvenirMedium19  = UIFont(name: "Avenir-Medium", size: 19.0)
    static let AvenirMedium18  = UIFont(name: "Avenir-Medium", size: 18.0)
    static let AvenirMedium17  = UIFont(name: "Avenir-Medium", size: 17.0)
    static let AvenirMedium16  = UIFont(name: "Avenir-Medium", size: 16.0)
    static let AvenirMedium15  = UIFont(name: "Avenir-Medium", size: 15.0)
    static let AvenirMedium14  = UIFont(name: "Avenir-Medium", size: 14.0)
    static let AvenirMedium13  = UIFont(name: "Avenir-Medium", size: 13.0)
    static let AvenirMedium12  = UIFont(name: "Avenir-Medium", size: 12.0)
    static let AvenirMedium11  = UIFont(name: "Avenir-Medium", size: 11.0)
    static let AvenirMedium10  = UIFont(name: "Avenir-Medium", size: 10.0)

    static let AvenirLight14  = UIFont(name: "Avenir-Light", size: 14.0)
    static let AvenirLight15  = UIFont(name: "Avenir-Light", size: 15.0)
    static let AvenirLight16  = UIFont(name: "Avenir-Light", size: 16.0)
    static let AvenirLight17  = UIFont(name: "Avenir-Light", size: 17.0)
    static let AvenirLight18  = UIFont(name: "Avenir-Light", size: 18.0)
    static let AvenirLight19  = UIFont(name: "Avenir-Light", size: 19.0)
    static let AvenirLight20  = UIFont(name: "Avenir-Light", size: 20.0)
}

enum MessageType {
    case photo
    case text
    case location
}

enum MessageOwner {
    case sender
    case receiver
}

//Global variables
struct GlobalVariables {
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let purple = UIColor.rbg(r: 161, g: 114, b: 255)
}

extension UIColor {
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
    
    static var sampleRed = UIColor(red: 252/255, green: 70/255, blue: 93/255, alpha: 1)
    static var sampleGreen = UIColor(red: 49/255, green: 193/255, blue: 109/255, alpha: 1)
    static var sampleBlue = UIColor(red: 52/255, green: 154/255, blue: 254/255, alpha: 1)
    
    static var passBtnColor = UIColor(red: 255/255, green: 46/255, blue: 81/255, alpha: 1)
    static var likeBtnColor = UIColor(red: 58/255, green: 225/255, blue: 108/255, alpha: 1)
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    
    return label.frame.height
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
