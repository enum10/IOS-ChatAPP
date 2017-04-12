//
//  Message.swift
//  ChatApp
//
//  Created by Inam Ahmad-zada on 2017-04-08.
//  Copyright © 2017 Inam Ahmad-zada. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromID: String?
    var toID: String?
    var timestamp: NSNumber?
    var text: String?
    
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    func chatPartnerID() -> String? {
        
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
    }
    
    init(dictionary: [String: AnyObject]) {
        
        fromID = dictionary["fromID"] as? String
        toID = dictionary["toID"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        text = dictionary["text"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
}
