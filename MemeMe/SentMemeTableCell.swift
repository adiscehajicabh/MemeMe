//
//  SentMemeTableCell.swift
//  MemeMe
//
//  Created by Adis Cehajic on 04/06/2017.
//  Copyright © 2017 Adis Cehajic. All rights reserved.
//

import UIKit

class SentMemeTableCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
