//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Adis Cehajic on 04/06/2017.
//  Copyright © 2017 Adis Cehajic. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController {

    // MARK: Outlet properties

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Properties

    let sentMemeCollectionCellIdentifier = "SentMemeCollectionCellIdentifier"

    // MARK: ViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the appearance of the collection view items.
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
}

extension SentMemesCollectionViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.allMemes().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sentMemeCollectionCellIdentifier, for: indexPath) as! SentMemeCollectionCell
        
        let meme = Meme.allMemes()[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
}

extension SentMemesCollectionViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.memeIndex = indexPath.row
                
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
