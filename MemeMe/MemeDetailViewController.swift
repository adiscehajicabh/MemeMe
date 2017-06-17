//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Adis Cehajic on 04/06/2017.
//  Copyright © 2017 Adis Cehajic. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Outlet properties

    @IBOutlet weak var memeImageView: UIImageView!

    // MARK: Properties

    var meme:Meme!
    var memeIndex:Int!
    
    // MARK: ViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable edit button and set edit button action.
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.action = #selector(editMeme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Find meme at selected index.
        meme = Meme.allMemes()[memeIndex!]
        memeImageView.image = meme.memedImage
    }
    
    // MARK: Private methods
    
    // This method is edit button action method and it opens meme editor view controller with meme index.
    func editMeme() {
        
        let memeEditorViewController = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        memeEditorViewController.memeIndex = memeIndex
        memeEditorViewController.modalTransitionStyle = .crossDissolve
        let navigationController = UINavigationController(rootViewController: memeEditorViewController)
        
        present(navigationController, animated: true, completion: nil)
    }
}
