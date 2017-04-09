//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Inam Ahmad-zada on 2017-04-06.
//  Copyright © 2017 Inam Ahmad-zada. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var messagesController: MessageViewController?
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Name"
        tf.autocorrectionType = .no
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameFieldSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailFieldSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordFieldSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var logoImageSelectedView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noprofile")
        return imageView
    }()
    
    lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = UIColor.white
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.placeholder = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "" : "Name"
        nameTextField.text = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? "" : nameTextField.text
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            print("This form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, err) in
            if err != nil{
                print(err ?? "")
                return
            }
            
            //self.messagesController?.navigationItem.title = ""
            self.messagesController?.fetchUserAndSetNavbarTitle()
            self.dismiss(animated: true, completion: nil)
        })
    }
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(logoImage)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginButton()
        setupLogoImage()
        setupLoginRegisterSegmentedControl()
    }
    
    func setupLogoImage(){
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -24).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupInputsContainerView(){
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameFieldSeperator)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailFieldSeperator)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordFieldSeperator)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameFieldSeperator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameFieldSeperator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameFieldSeperator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameFieldSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailFieldSeperator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailFieldSeperator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailFieldSeperator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailFieldSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        passwordFieldSeperator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordFieldSeperator.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordFieldSeperator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordFieldSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupLoginButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLoginRegisterSegmentedControl(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
