//
//  cacheImage.swift
//  zawtar
//
//  Created by kassem on 5/17/18.
//  Copyright © 2018 kassem. All rights reserved.
//

import UIKit
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString : String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: ({ (data, response, error) in
            if  error == nil {
                DispatchQueue.main.async {
                    if let downloadImage : UIImage = UIImage(data: data!){
                        imageCache.setObject(downloadImage, forKey: urlString as NSString)
                       self.image = downloadImage
                    }
                }
                
                
            }
            
        })).resume()
        
        }
//        let storageRef = Storage.storage().reference()
        
  //      let storage = storageRef.child(urlString)
        
 //       storage.getData(maxSize: 1*2024*2024) { (data, error) in
            
        
       
        }



