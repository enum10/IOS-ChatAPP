//
//  ChatLogController.swift
//  ChatApp
//
//  Created by Inam Ahmad-zada on 2017-04-08.
//  Copyright © 2017 Inam Ahmad-zada. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: User?
    {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    lazy var textField : UITextField = {
        let input = UITextField()
        input.placeholder = "Enter message..."
        input.translatesAutoresizingMaskIntoConstraints = false
        input.delegate = self
        return input
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        setupInputComponents()
    }
    
    func setupInputComponents(){
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    
        containerView.addSubview(textField)
        
        textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperator = UIView()
        seperator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperator)
        
        seperator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func handleSend(){
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toID = user!.id!
        let fromID = FIRAuth.auth()!.currentUser!.uid
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        
        let values: [String: AnyObject] = ["text": textField.text! as AnyObject, "toID": toID as AnyObject, "fromID": fromID as AnyObject, "timestamp": timestamp]
        childRef.updateChildValues(values)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
