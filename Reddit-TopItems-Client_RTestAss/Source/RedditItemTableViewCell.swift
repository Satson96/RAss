//
//  RedditItemTableViewCell.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import UIKit

class RedditItemTableViewCell: UITableViewCell {
    static var identifier = "RedditItemTableViewCell"
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemCommentsLabel: UILabel!
    
    var onImagePressed: (()->())?
    
    var viewModel: RedditItemViewModel!
    
    fileprivate var defaultImageIsUsed: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImageView.tintColor = UIColor.lightGray
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(itemImageViewTapped))
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(tapGestureRecognizer)
        
        itemImageView.addInteraction(UIContextMenuInteraction(delegate: self))
        
        
        setDefaultValues()
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
        
        defaultImageIsUsed = true
    }
    
    
    func show(image: UIImage) {
        imageLoadingIndicatorView.stopAnimating()
        itemImageView.image = image
        
        defaultImageIsUsed = false
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

extension RedditItemTableViewCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {        
        return UIContextMenuConfiguration(identifier: nil) { () -> UIViewController? in
            guard let viewModel = self.viewModel.getImageViewerViewModel() else {
                return nil
            }
            
            let vc = ImageViewerViewController.build()
            vc.viewModel = viewModel
            
            return vc
        } actionProvider: { _ in
            var children = [UIMenuElement]()

            if !self.defaultImageIsUsed {
                let saveToPhotos = UIAction(title: "Add to Photos",
                                            image: UIImage(systemName: "square.and.arrow.down")) {_ in
                    if let image = self.itemImageView.image {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                }

                children.append(saveToPhotos)
            }


            return UIMenu(title: "", children: children)
        }

    }
    
    
}
