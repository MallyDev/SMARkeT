//
//  ImageStore.swift
//  App
//
//  Created by Maria Laura Bisogno on 05/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
}
