//
//  Match.swift
//  SenpaiME
//
//  Created by Macintoshi on 11/26/18.
//  Copyright © 2018 Macintoshi. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Match {
    
    //MARK: Properties
    let user: User
    var isChat: Bool
    var lastMessage: Message
    
    //MARK: Methods
    class func showMatches(completion: @escaping ([Match]) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            var matches = [Match]()
            Database.database().reference().child(DatabaseKeys.matches).child(currentUserID).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    matches.removeAll()
                    for snap in snapshot.children {
                        let fromID = (snap as! DataSnapshot).key
                        let values = (snap as! DataSnapshot).value as! [String: Any]
                        
                        if ((values["i_like"] as? String ?? "0") == "1") && ((values["like_me"] as? String ?? "0") == "1") {
                            let is_Chat = (values["isChat"] as? String ?? "0") == "1" ? true : false
                            
                            User.otherInfo(forUserID: fromID, completion: { (user) in
                                let emptyMessage = Message.init(type: .text, content: "No Message.", owner: .sender, timestamp: 0, isRead: true)
                                let match = Match.init(user: user, isChat: is_Chat, lastMessage: emptyMessage)
                                matches.append(match)
                                if is_Chat == true {
                                    let chat_Id = (values["chat_id"] as? String ?? "")
                                    if chat_Id != "" {
                                        match.lastMessage.downloadLastMessage(forLocation: chat_Id, completion: {
                                            completion(matches)
                                        })
                                    }else {
                                        completion(matches)
                                    }
                                    
                                }else {
                                    completion(matches)
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
    //MARK: Inits
    init(user: User, isChat: Bool, lastMessage: Message) {
        self.user = user
        self.isChat = isChat
        self.lastMessage = lastMessage
    }
    
    class func showPopMatches(completion: @escaping ([Match]) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            var matches = [Match]()
            Database.database().reference().child(DatabaseKeys.matches).child(currentUserID).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    matches.removeAll()
                    for snap in snapshot.children {
                        let fromID = (snap as! DataSnapshot).key
                        let values = (snap as! DataSnapshot).value as! [String: Any]
                        
                        if ((values["i_like"] as? String ?? "") == "1") && ((values["like_me"] as? String ?? "") == "1") && ((values["is_show"] as? String ?? "") != "1") {
                            let is_Chat = (values["isChat"] as? String ?? "0") == "1" ? true : false
                            User.otherInfo(forUserID: fromID, completion: { (user) in
                                let emptyMessage = Message.init(type: .text, content: "No Message.", owner: .sender, timestamp: 0, isRead: true)
                                let match = Match.init(user: user, isChat: is_Chat, lastMessage: emptyMessage)
                                matches.append(match)
                                if is_Chat == true {
                                    let chat_Id = (values["chat_id"] as? String ?? "")
                                    if chat_Id != "" {
                                        match.lastMessage.downloadLastMessage(forLocation: chat_Id, completion: {
                                            completion(matches)
                                        })
                                    }else {
                                        completion(matches)
                                    }
                                }else {
                                    completion(matches)
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
    class func addIsPopShow(forUserID: String, completion: @escaping (Bool) -> Swift.Void) {
        let ref = Database.database().reference().child(DatabaseKeys.matches)
        let params = ["is_show": "1"] as [String : Any]
        ref.child(Auth.auth().currentUser!.uid).child(forUserID).updateChildValues(params) { (error, ref) in
            if error == nil {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
}
