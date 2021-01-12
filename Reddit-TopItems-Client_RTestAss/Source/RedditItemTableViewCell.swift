//
//  RedditItemTableViewCell.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import UIKit

class RedditItemTableViewCell: UITableViewCell {
    static var identifier = "RedditItemTableViewCell"
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemCommentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
