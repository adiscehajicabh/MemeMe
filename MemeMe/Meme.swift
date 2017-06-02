//
//  Meme.swift
//  MemeMe
//
//  Created by Adis Cehajic on 15/05/2017.
//  Copyright © 2017 Adis Cehajic. All rights reserved.
//

import UIKit

// Meme model representation.

struct Meme {
    
    // MARK: Properties
    
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage
    var memedImage: UIImage
    
    // MARK: Private methods
    
    func save() {
        // Get all memes array from AppDelegate and add meme in the array.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allMemes.append(self)
    }
}
