//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation
import UIKit
import Firebase
import CoreLocation

class User: NSObject, NSCoding {
    
    //MARK: Properties
    let uid: String
    let first_name: String
    let last_name: String
    let token: String
    let user_pics: [String]
    let email: String
    let location: String
    let coor_lat: String
    let coor_lng: String
    let birthday: String
    let age: String
    let gender: String
    let isfacebook: String
    
    let watching: String
    let mangas: String
    let cosplay: String
    let attending: String
    let about: String
    
    let show_distance: String
    let show_gender: String
    let show_age: String
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
//                user?.sendEmailVerification(completion: nil)
//                let storageRef = Storage.storage().reference().child("usersProfilePics").child(user!.uid)
//                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
//                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
//                    if err == nil {
//                        let path = metadata?.downloadURL()?.absoluteString
//                        let values = ["name": withName, "email": email, "profilePicLink": path!]
//                        Database.database().reference().child("users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
//                            if errr == nil {
//                                let userInfo = ["email" : email, "password" : password]
//                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                completion(true)
//                            }
//                        })
//                    }
//                })
            }
            else {
                completion(false)
            }
        })
    }
    
   class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
   class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let first_name = data["first_name"] as? String ?? ""
                let last_name = data["last_name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                
                let user_pics = data["user_pics"] as? [String] ?? []
                
                let location = data["location"] as? String ?? ""
                let coor_lat = data["coor_lat"] as? String ?? ""
                let coor_lng = data["coor_lng"] as? String ?? ""
                let birthday = data["birthday"] as? String ?? ""
                let age = data["age"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let isfacebook = data["isfacebook"] as? String ?? ""
                
                let watching = data["watching"] as? String ?? ""
                let mangas = data["mangas"] as? String ?? ""
                let cosplay = data["cosplay"] as? String ?? ""
                let attending = data["attending"] as? String ?? ""
                let about = data["about"] as? String ?? ""
                
                let show_distance = data["show_distance"] as? String ?? ""
                let show_gender = data["show_gender"] as? String ?? ""
                let show_age = data["show_age"] as? String ?? ""
                
                let cUser = User.init(uid: forUserID, first_name: first_name, last_name: last_name, token: "", user_pics: user_pics, email: email, location: location, coor_lat: coor_lat, coor_lng: coor_lng, birthday: birthday, age: age, gender: gender, isfacebook: isfacebook, watching: watching, mangas: mangas, cosplay: cosplay, attending: attending, about: about, show_distance: show_distance, show_gender: show_gender, show_age: show_age)
                
                let userDefaults = UserDefaults.standard
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: cUser)
                userDefaults.set(encodedData, forKey: StaticDATA.currentUser)
                userDefaults.synchronize()
                
                completion(cUser)
            }
        })
    }
    
    class func otherInfo(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let first_name = data["first_name"] as? String ?? ""
                let last_name = data["last_name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                
                let user_pics = data["user_pics"] as? [String] ?? []
                
                let location = data["location"] as? String ?? ""
                let coor_lat = data["coor_lat"] as? String ?? ""
                let coor_lng = data["coor_lng"] as? String ?? ""
                let birthday = data["birthday"] as? String ?? ""
                let age = data["age"] as? String ?? ""
                let gender = data["gender"] as? String ?? ""
                let isfacebook = data["isfacebook"] as? String ?? ""
                
                let watching = data["watching"] as? String ?? ""
                let mangas = data["mangas"] as? String ?? ""
                let cosplay = data["cosplay"] as? String ?? ""
                let attending = data["attending"] as? String ?? ""
                let about = data["about"] as? String ?? ""
                
                let show_distance = data["show_distance"] as? String ?? ""
                let show_gender = data["show_gender"] as? String ?? ""
                let show_age = data["show_age"] as? String ?? ""
                
                let cUser = User.init(uid: forUserID, first_name: first_name, last_name: last_name, token: "", user_pics: user_pics, email: email, location: location, coor_lat: coor_lat, coor_lng: coor_lng, birthday: birthday, age: age, gender: gender, isfacebook: isfacebook, watching: watching, mangas: mangas, cosplay: cosplay, attending: attending, about: about, show_distance: show_distance, show_gender: show_gender, show_age: show_age)
                
                completion(cUser)
            }
        })
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
//                let name = credentials["name"]!
//                let email = credentials["email"]!
                let link = URL.init(string: credentials["profilePicLink"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
//                        let profilePic = UIImage.init(data: data!)
//                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!)
//                        completion(user)
                    }
                }).resume()
            }
        })
    }
    // Filter User
    class func downloadFilterUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        
        var keysArray = [String]()
        var valuesArray = [String: Any]()
        
//        Database.database().reference().child(DatabaseKeys.matches).child(Auth.auth().currentUser!.uid).observe(.value) { (cSnapshot) in
        
        Database.database().reference().child(DatabaseKeys.matches).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (cSnapshot) in
            
            let userDefaults = UserDefaults.standard
            let decoded  = userDefaults.object(forKey: StaticDATA.currentUser) as! Data
            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
            let show_Ages = decodedUser.show_age.components(separatedBy: "-")
            let my_coordinate = CLLocation(latitude: Double(decodedUser.coor_lat)!, longitude: Double(decodedUser.coor_lng)!)
            
            let ref = Database.database().reference().child(DatabaseKeys.users)
            var query = DatabaseQuery()
            if decodedUser.show_gender == "Men" {
                query = ref.queryOrdered(byChild: "gender").queryEqual(toValue: "Male")
            }else if decodedUser.show_gender == "Women" {
                query = ref.queryOrdered(byChild: "gender").queryEqual(toValue: "Female")
            }else {
                query = ref
            }
            
            
            if cSnapshot.exists() { // exist Matches
                let cDatas = cSnapshot.value as! [String: Any]
                keysArray = Array(cDatas.keys)
                valuesArray = cDatas
                
                query.observe(.childAdded, with: { (snapshot) in
                    
                    if keysArray.contains(snapshot.key) { // exist Matches
                        let value = valuesArray[snapshot.key] as! [String:String]
                        let i_like = value["i_like"] ?? ""
//                        let like_me = value["like_me"] as? String ?? ""
                        if i_like == "" {
                            let id = snapshot.key
                            let data = snapshot.value as! [String: Any]
                            if id != exceptID {
                                let first_name = data["first_name"] as? String ?? ""
                                let last_name = data["last_name"] as? String ?? ""
                                let email = data["email"] as? String ?? ""
                                
                                let user_pics = data["user_pics"] as? [String] ?? []
                                
                                let location = data["location"] as? String ?? ""
                                let coor_lat = data["coor_lat"] as? String ?? "0.0"
                                let coor_lng = data["coor_lng"] as? String ?? "0.0"
                                let birthday = data["birthday"] as? String ?? ""
                                let age = data["age"] as? String ?? ""
                                let gender = data["gender"] as? String ?? ""
                                let isfacebook = data["isfacebook"] as? String ?? ""
                                
                                let watching = data["watching"] as? String ?? ""
                                let mangas = data["mangas"] as? String ?? ""
                                let cosplay = data["cosplay"] as? String ?? ""
                                let attending = data["attending"] as? String ?? ""
                                let about = data["about"] as? String ?? ""
                                
                                let show_distance = data["show_distance"] as? String ?? "100"
                                let show_gender = data["show_gender"] as? String ?? ""
                                let show_age = data["show_age"] as? String ?? "18-45"
                                
                                
                                let their_Coordinate = CLLocation(latitude: Double(coor_lat)!, longitude: Double(coor_lng)!)
                                let radiusInMetter = my_coordinate.distance(from: their_Coordinate)
                                
                                if (decodedUser.show_distance == "100") || ((radiusInMetter/1609.344) < Double(decodedUser.show_distance)!) {
                                    if Int(show_Ages[0])! <= Int(age)! && Int(show_Ages[1])! >= Int(age)! {
                                        
                                        
                                        
                                        let cUser = User.init(uid: id, first_name: first_name, last_name: last_name, token: "", user_pics: user_pics, email: email, location: location, coor_lat: coor_lat, coor_lng: coor_lng, birthday: birthday, age: age, gender: gender, isfacebook: isfacebook, watching: watching, mangas: mangas, cosplay: cosplay, attending: attending, about: about, show_distance: show_distance, show_gender: show_gender, show_age: show_age)
                                        
                                        completion(cUser)
                                    }
                                }
                            }
                        }
                    }else { // not exist Matches
                        let id = snapshot.key
                        let data = snapshot.value as! [String: Any]
                        if id != exceptID {
                            let first_name = data["first_name"] as? String ?? ""
                            let last_name = data["last_name"] as? String ?? ""
                            let email = data["email"] as? String ?? ""
                            
                            let user_pics = data["user_pics"] as? [String] ?? []
                            
                            let location = data["location"] as? String ?? ""
                            let coor_lat = data["coor_lat"] as? String ?? "0.0"
                            let coor_lng = data["coor_lng"] as? String ?? "0.0"
                            let birthday = data["birthday"] as? String ?? ""
                            let age = data["age"] as? String ?? ""
                            let gender = data["gender"] as? String ?? ""
                            let isfacebook = data["isfacebook"] as? String ?? ""
                            
                            let watching = data["watching"] as? String ?? ""
                            let mangas = data["mangas"] as? String ?? ""
                            let cosplay = data["cosplay"] as? String ?? ""
                            let attending = data["attending"] as? String ?? ""
                            let about = data["about"] as? String ?? ""
                            
                            let show_distance = data["show_distance"] as? String ?? "100"
                            let show_gender = data["show_gender"] as? String ?? ""
                            let show_age = data["show_age"] as? String ?? "18-45"
                            
                            
                            let their_Coordinate = CLLocation(latitude: Double(coor_lat)!, longitude: Double(coor_lng)!)
                            let radiusInMetter = my_coordinate.distance(from: their_Coordinate)
                            
                            if (decodedUser.show_distance == "100") || ((radiusInMetter/1609.344) < Double(decodedUser.show_distance)!) {
                                if Int(show_Ages[0])! <= Int(age)! && Int(show_Ages[1])! >= Int(age)! {
                                    
                                    
                                    
                                    let cUser = User.init(uid: id, first_name: first_name, last_name: last_name, token: "", user_pics: user_pics, email: email, location: location, coor_lat: coor_lat, coor_lng: coor_lng, birthday: birthday, age: age, gender: gender, isfacebook: isfacebook, watching: watching, mangas: mangas, cosplay: cosplay, attending: attending, about: about, show_distance: show_distance, show_gender: show_gender, show_age: show_age)
                                    
                                    completion(cUser)
                                }
                            }
                        }
                        
                    }
                })
            }else { // not exist Matches
                // 1 Mile = 1609.34 m
                query.observe(.childAdded, with: { (snapshot) in
                    
                    let id = snapshot.key
                    let data = snapshot.value as! [String: Any]
                    if id != exceptID {
                        let first_name = data["first_name"] as? String ?? ""
                        let last_name = data["last_name"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        
                        let user_pics = data["user_pics"] as? [String] ?? []
                        
                        let location = data["location"] as? String ?? ""
                        let coor_lat = data["coor_lat"] as? String ?? "0.0"
                        let coor_lng = data["coor_lng"] as? String ?? "0.0"
                        let birthday = data["birthday"] as? String ?? ""
                        var age = data["age"] as? String ?? ""
                        let gender = data["gender"] as? String ?? ""
                        let isfacebook = data["isfacebook"] as? String ?? ""
                        
                        let watching = data["watching"] as? String ?? ""
                        let mangas = data["mangas"] as? String ?? ""
                        let cosplay = data["cosplay"] as? String ?? ""
                        let attending = data["attending"] as? String ?? ""
                        let about = data["about"] as? String ?? ""
                        
                        let show_distance = data["show_distance"] as? String ?? "100"
                        let show_gender = data["show_gender"] as? String ?? ""
                        let show_age = data["show_age"] as? String ?? "18-45"
                        
                        
                        let their_Coordinate = CLLocation(latitude: Double(coor_lat)!, longitude: Double(coor_lng)!)
                        let radiusInMetter = my_coordinate.distance(from: their_Coordinate)
                        
                        if (decodedUser.show_distance == "100") || ((radiusInMetter/1609.344) < Double(decodedUser.show_distance)!) {
                            if age == "" {
                                age = "25"
                            }
                            if Int(show_Ages[0])! <= Int(age)! && Int(show_Ages[1])! >= Int(age)! {
                                
                                
                                
                                let cUser = User.init(uid: id, first_name: first_name, last_name: last_name, token: "", user_pics: user_pics, email: email, location: location, coor_lat: coor_lat, coor_lng: coor_lng, birthday: birthday, age: age, gender: gender, isfacebook: isfacebook, watching: watching, mangas: mangas, cosplay: cosplay, attending: attending, about: about, show_distance: show_distance, show_gender: show_gender, show_age: show_age)
                                
                                completion(cUser)
                            }
                        }
                    }
                })
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        var keysArray = [String]()
//        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("matches").observeSingleEvent(of: .value) { (cSnapshot) in
//
//            let userDefaults = UserDefaults.standard
//
//            let decoded  = userDefaults.object(forKey: StaticDATA.currentUser) as! Data
//            let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
//
//            let show_Ages = decodedUser.show_age.components(separatedBy: "-")
//
//            let my_coordinate = CLLocation(latitude: Double(decodedUser.coor_lat)!, longitude: Double(decodedUser.coor_lng)!)
//
//            let ref = Database.database().reference().child("users")
//            var query = DatabaseQuery()
//
//            if decodedUser.show_gender == "Men" {
//                query = ref.queryOrdered(byChild: "gender").queryEqual(toValue: "Male")
//            }else if decodedUser.show_gender == "Women" {
//                query = ref.queryOrdered(byChild: "gender").queryEqual(toValue: "Female")
//            }else {
//                query = ref
//            }
//
//
//
//
//            if cSnapshot.exists() {
//                let cDatas = cSnapshot.value as! [String: Any]
//
//                keysArray = Array(cDatas.keys)
//
//                // 1 Mile = 1609.34 m
//                query.observe(.childAdded, with: { (snapshot) in
//
//                    let id = snapshot.key
//                    let data = snapshot.value as! [String: Any]
//
//                    if !keysArray.contains(snapshot.key) {
//
//                        if id != exceptID {
//                            let first_name = data["first_name"] as? String ?? ""
//                            let last_name = data["last_name"] as? String ?? ""
//                            let email = data["email"] as? String ?? ""
//
//                            let user_pics = data["user_pics"] as? [String] ?? []
//
//                            let location = data["location"] as? String ?? ""
//                            let coor_lat = data["coor_lat"] as? String ?? "0.0"
//                            let coor_lng = data["coor_lng"] as? String ?? "0.0"
//                            let birthday = data["birthday"] as? String ?? ""
//                            let age = data["age"] as? String ?? ""
//                            let gender = data["gender"] as? String ?? ""
//                            let isfacebook = data["isfacebook"] as? String ?? ""
//
//                            let watching = data["watching"] as? String ?? ""
//                            let mangas = data["mangas"] as? String ?? ""
//                            let cosplay = data["cosplay"] as? String ?? ""
//                            let attending = data["attending"] as? String ?? ""
//                            let about = data["about"] as? String ?? ""
//
//                            let show_distance = data["show_distance"] as? String ?? "100"
//                            let show_gender = data["show_gender"] as? String ?? ""
//                            let show_age = data["show_age"] as? String ?? "18-45"
//
//
//                            let their_Coordinate = CLLocation(latitude: Double(coor_lat)!, longitude: Double(coor_lng)!)
//                            let radiusInMetter = my_coordinate.distance(from: their_Coordinate)
//
//                            if (decodedUser.show_distance == "100") || ((radiusInMetter/1609.344) < Double(decodedUser.show_distance)!) {
//                                if Int(show_Ages[0])! <= Int(age)! && Int(show_Ages[1])! >= Int(age)! {
//
//                                    let cUser = User.init(uid: id, first_name: first_name, last_name: last_name, token: "", user_pics: user_pics, email: email, location: location, coor_lat: coor_lat, coor_lng: coor_lng, birthday: birthday, age: age, gender: gender, isfacebook: isfacebook, watching: watching, mangas: mangas, cosplay: cosplay, attending: attending, about: about, show_distance: show_distance, show_gender: show_gender, show_age: show_age)
//
//                                    completion(cUser)
//                                }
//                            }
//                        }
//                    }else {
//
////                        if let index = keysArray.index(of: snapshot.key) {
////                            cDatas.remove(at: index)
////                        }
//
//
//
//
//
//
//
//
//
//
//
//
//                    }
//                })
//
//            }else {
//
//                // 1 Mile = 1609.34 m
//                query.observe(.childAdded, with: { (snapshot) in
//
//                    let id = snapshot.key
//                    let data = snapshot.value as! [String: Any]
//                    if id != exceptID {
//                        let first_name = data["first_name"] as? String ?? ""
//                        let last_name = data["last_name"] as? String ?? ""
//                        let email = data["email"] as? String ?? ""
//
//                        let user_pics = data["user_pics"] as? [String] ?? []
//
//                        let location = data["location"] as? String ?? ""
//                        let coor_lat = data["coor_lat"] as? String ?? "0.0"
//                        let coor_lng = data["coor_lng"] as? String ?? "0.0"
//                        let birthday = data["birthday"] as? String ?? ""
//                        let age = data["age"] as? String ?? ""
//                        let gender = data["gender"] as? String ?? ""
//                        let isfacebook = data["isfacebook"] as? String ?? ""
//
//                        let watching = data["watching"] as? String ?? ""
//                        let mangas = data["mangas"] as? String ?? ""
//                        let cosplay = data["cosplay"] as? String ?? ""
//                        let attending = data["attending"] as? String ?? ""
//                        let about = data["about"] as? String ?? ""
//
//                        let show_distance = data["show_distance"] as? String ?? "100"
//                        let show_gender = data["show_gender"] as? String ?? ""
//                        let show_age = data["show_age"] as? String ?? "18-45"
//
//
//                        let their_Coordinate = CLLocation(latitude: Double(coor_lat)!, longitude: Double(coor_lng)!)
//                        let radiusInMetter = my_coordinate.distance(from: their_Coordinate)
//
//                        if (decodedUser.show_distance == "100") || ((radiusInMetter/1609.344) < Double(decodedUser.show_distance)!) {
//                            if Int(show_Ages[0])! <= Int(age)! && Int(show_Ages[1])! >= Int(age)! {
//
//
//
//                                let cUser = User.init(uid: id, first_name: first_name, last_name: last_name, token: "", user_pics: user_pics, email: email, location: location, coor_lat: coor_lat, coor_lng: coor_lng, birthday: birthday, age: age, gender: gender, isfacebook: isfacebook, watching: watching, mangas: mangas, cosplay: cosplay, attending: attending, about: about, show_distance: show_distance, show_gender: show_gender, show_age: show_age)
//
//                                completion(cUser)
//                            }
//                        }
//                    }
//
//
//
//                })
//
//            }
//
//
//
//
//
//        }
    }
    

    
    class func likeUser(forUserID: String, completion: @escaping (Bool) -> Swift.Void) {
        let ref1 = Database.database().reference().child(DatabaseKeys.matches)
        let params_1 = ["i_like": "1"] as [String : Any]
        ref1.child(Auth.auth().currentUser!.uid).child(forUserID).updateChildValues(params_1) { (error, ref) in
            if error == nil {
                let ref2 = Database.database().reference().child(DatabaseKeys.matches)
                let params_2 = ["like_me": "1"] as [String : Any]
                ref2.child(forUserID).child(Auth.auth().currentUser!.uid).updateChildValues(params_2) { (error, ref) in
                    if error == nil {
                        completion(true)
                    }else {
                        completion(false)
                    }
                }
            }else {
                completion(false)
            }
        }
    }
    
    class func unlikeUser(forUserID: String, completion: @escaping (Bool) -> Swift.Void) {
        let ref1 = Database.database().reference().child(DatabaseKeys.matches)
        let params_1 = ["i_like": "0"] as [String : Any]
        ref1.child(Auth.auth().currentUser!.uid).child(forUserID).updateChildValues(params_1) { (error, ref) in
            if error == nil {
                let ref2 = Database.database().reference().child(DatabaseKeys.matches)
                let params_2 = ["like_me": "0"] as [String : Any]
                ref2.child(forUserID).child(Auth.auth().currentUser!.uid).updateChildValues(params_2) { (error, ref) in
                    if error == nil {
                        completion(true)
                    }else {
                        completion(false)
                    }
                }
            }else {
                completion(false)
            }
        }
    }
    
    class func addChatUser(forUserID: String, completion: @escaping (Bool) -> Swift.Void) {
        let ref1 = Database.database().reference().child(DatabaseKeys.matches)
        let params = ["isChat": "1"] as [String : Any]
        ref1.child(Auth.auth().currentUser!.uid).child(forUserID).updateChildValues(params) { (error, ref) in
            if error == nil {
                let ref2 = Database.database().reference().child(DatabaseKeys.matches)
                ref2.child(forUserID).child(Auth.auth().currentUser!.uid).updateChildValues(params) { (error, ref) in
                    if error == nil {
                        completion(true)
                    }else {
                        completion(false)
                    }
                }
            }else {
                completion(false)
            }
        }
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }

    
    //MARK: Inits
    init(uid: String, first_name: String, last_name: String, token: String, user_pics: [String], email: String, location: String, coor_lat: String, coor_lng: String, birthday: String, age: String, gender: String, isfacebook: String, watching: String, mangas: String, cosplay: String, attending: String, about: String, show_distance: String, show_gender: String, show_age: String) {
        
        self.uid = uid
        self.first_name = first_name
        self.last_name = last_name
        self.token = token
        self.user_pics = user_pics
        self.email = email
        self.location = location
        self.coor_lat = coor_lat
        self.coor_lng = coor_lng
        self.birthday = birthday
        self.age = age
        self.gender = gender
        self.isfacebook = isfacebook
        
        self.watching = watching
        self.mangas = mangas
        self.cosplay = cosplay
        self.attending = attending
        self.about = about
        
        self.show_distance = show_distance
        self.show_gender = show_gender
        self.show_age = show_age
    }
    
    required init(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as! String
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as! String
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.user_pics = aDecoder.decodeObject(forKey: "user_pics") as! [String]
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.location = aDecoder.decodeObject(forKey: "location") as! String
        self.coor_lat = aDecoder.decodeObject(forKey: "coor_lat") as! String
        self.coor_lng = aDecoder.decodeObject(forKey: "coor_lng") as! String
        self.birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        self.age = aDecoder.decodeObject(forKey: "age") as! String
        self.gender = aDecoder.decodeObject(forKey: "gender") as! String
        self.isfacebook = aDecoder.decodeObject(forKey: "isfacebook") as! String
        
        self.watching = aDecoder.decodeObject(forKey: "watching") as! String
        self.mangas = aDecoder.decodeObject(forKey: "mangas") as! String
        self.cosplay = aDecoder.decodeObject(forKey: "cosplay") as! String
        self.attending = aDecoder.decodeObject(forKey: "attending") as! String
        self.about = aDecoder.decodeObject(forKey: "about") as! String
        
        self.show_distance = aDecoder.decodeObject(forKey: "show_distance") as! String
        self.show_gender = aDecoder.decodeObject(forKey: "show_gender") as! String
        self.show_age = aDecoder.decodeObject(forKey: "show_age") as! String

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(user_pics, forKey: "user_pics")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(coor_lat, forKey: "coor_lat")
        aCoder.encode(coor_lng, forKey: "coor_lng")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(age, forKey: "age")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(isfacebook, forKey: "isfacebook")
        
        aCoder.encode(watching, forKey: "watching")
        aCoder.encode(mangas, forKey: "mangas")
        aCoder.encode(cosplay, forKey: "cosplay")
        aCoder.encode(attending, forKey: "attending")
        aCoder.encode(about, forKey: "about")
        
        aCoder.encode(show_distance, forKey: "show_distance")
        aCoder.encode(show_gender, forKey: "show_gender")
        aCoder.encode(show_age, forKey: "show_age")

    }
}

