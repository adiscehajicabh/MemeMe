//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Adis Cehajic on 04/06/2017.
//  Copyright © 2017 Adis Cehajic. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController {

    // MARK: Outlet properties

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties

    let sentMemeTableCellIdentifier = "SentMemeTableCellIdentifier"
    var selectedMeme:Meme!
    
    // MARK: ViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setEditing(false, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
    }
}

extension SentMemesTableViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Meme.allMemes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sentMemeTableCellIdentifier, for: indexPath) as! SentMemeTableCell
        
        let meme = Meme.allMemes()[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
        cell.memeText?.text = meme.topText! + " " + meme.bottomText!
        
        return cell
    }
}

extension SentMemesTableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.memeIndex = indexPath.row
        
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            Meme.remove(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
