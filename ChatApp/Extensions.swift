//
//  Extensions.swift
//  ChatApp
//
//  Created by Inam Ahmad-zada on 2017-04-08.
//  Copyright © 2017 Inam Ahmad-zada. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheWith(urlString: String){
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString){
            self.image = cachedImage
            return
        }
        //Otherwise
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    self.image = downloadedImage
                }
            }
        }
        task.resume()
        
    }
}
