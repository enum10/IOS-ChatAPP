//
//  LoginViewController+handlers.swift
//  ChatApp
//
//  Created by Inam Ahmad-zada on 2017-04-07.
//  Copyright © 2017 Inam Ahmad-zada. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImageView() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImagePicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImagePicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImagePicker = originalImage
        }
        
        if let selectedImage = selectedImagePicker {
            logoImageSelectedView.image = selectedImage
            logoImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text,
            let name = nameTextField.text else{
                print("Form is not valid")
                return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil{
                print(error ?? "")
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profileImages").child("\(imageName).jpeg")
            
            if let logoImageCached = self.logoImageSelectedView.image, let uploadData = UIImageJPEGRepresentation(logoImageCached, 0.2){
//            if let uploadData = UIImagePNGRepresentation(self.logoImageSelectedView.image!){
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, err) in
                    
                    if err != nil {
                        print(err ?? "")
                        return
                    }
                    
                    if let profileImage = metadata?.downloadURL()?.absoluteString{
                        let values = ["name": name, "email": email, "profileImage": profileImage]
                        self.registerUserIntoDatabase(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    private func registerUserIntoDatabase(uid: String, values: [String:AnyObject]){
        self.ref = FIRDatabase.database().reference(fromURL: "https://chat-ios-b7516.firebaseio.com/").child("users").child(uid)
        self.ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err ?? "")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
}
