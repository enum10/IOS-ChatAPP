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
    
    func chatPartnerID() -> String? {
        
        return fromID == FIRAuth.auth()?.currentUser?.uid ? toID : fromID
        
    }
}
