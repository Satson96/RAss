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
    
}
