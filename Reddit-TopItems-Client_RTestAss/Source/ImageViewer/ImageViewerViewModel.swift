//
//  ImageViewerViewModel.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 14.01.2021.
//

import Foundation

class ImageViewerViewModel: NSObject {
    var url: URL
    
    var title: String?

    @objc init(url: URL, title: String? = nil) {
        self.url = url
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        guard let nsUrl = coder.decodeObject(of: NSURL.self, forKey: ImageViewerViewModel.urlKey) else {
            fatalError("ImageViewerViewModel: url value can't be decoded.")
        }
        
        url   = nsUrl as URL
        title = coder.decodeObject(forKey: ImageViewerViewModel.titleKey) as? String
        
        super.init()
    }
     
}

extension ImageViewerViewModel: NSSecureCoding {
    
    static var redditDataSourceKey = "redditItemsDataSource"
    
    static var urlKey = "url"
    static var titleKey = "title"
    
    static var supportsSecureCoding: Bool {
        return true
    }

    func encode(with coder: NSCoder) {
        coder.encode(url, forKey: ImageViewerViewModel.urlKey)
        coder.encode(title, forKey: ImageViewerViewModel.titleKey)
    }

}
