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
    
    // MARK: Public methods
    
    static func allMemes() -> [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.allMemes
    }
    
    static func remove(index: Int) {
        // Get all memes array from AppDelegate and remove meme at index.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allMemes.remove(at: index)
    }
    
    static func update(meme: Meme, at index: Int) {
        // First remove existing meme from array and after that save new meme in the same position.
        remove(index: index)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allMemes.insert(meme, at: index)
    }
}
