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
    @IBOutlet weak var imageLoadingIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemCommentsLabel: UILabel!
    
    var onImagePressed: (()->())?
    
    var viewModel: RedditItemViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDefaultValues()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(itemImageViewTapped))
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaultValues()
    }
    
    private func setDefaultValues() {
        showDefaultImage()
        
        itemTitleLabel.text       = ""
        itemDescriptionLabel.text = ""
        itemCommentsLabel.text    = ""
    }
    
    func showDefaultImage() {
        imageLoadingIndicatorView.stopAnimating()
        itemImageView.image = UIImage(systemName: "photo.fill.on.rectangle.fill")
        itemImageView.tintColor = UIColor.lightGray
    }
    
    func configure(viewModel: RedditItemViewModel) {
        self.viewModel = viewModel
        
        itemTitleLabel.text       = viewModel.titleText
        itemDescriptionLabel.text = viewModel.itemDescriptionText
        itemCommentsLabel.text    = viewModel.commentsText
    }
    
    @objc func itemImageViewTapped() {
        onImagePressed?()
    }

    

}
