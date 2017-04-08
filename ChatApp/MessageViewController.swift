//
//  ViewController.swift
//  ChatApp
//
//  Created by Inam Ahmad-zada on 2017-04-06.
//  Copyright © 2017 Inam Ahmad-zada. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        
        let image = UIImage(named: "create")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        }
    
    func handleTitleTap(){
        let chatlogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatlogController, animated: true)
    }
    
    func handleNewMessage(){
        
        let newMessageController = NewMessageViewController()
        let navcontroller = UINavigationController(rootViewController: newMessageController)
        present(navcontroller, animated: true, completion: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else{
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
//                    self.navigationItem.title = dictionary["name"] as? String
                    
                    let user = User()
                    user.setValuesForKeys(dictionary)
                    self.setNavigationBarTitleView(user: user)
                }
                
            }, withCancel: nil)
        }
    }
    
    func setNavigationBarTitleView(user: User){
        
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40)
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTitleTap)))
    }
    
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }

}

