//
//  RedditItemViewModel.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 12.01.2021.
//

import Foundation

class RedditItemViewModel: NSObject {
    
    var dateFormatter: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }
    
    var item: RedditItem
    
    init(item: RedditItem) {
        self.item = item
    }
    
    var titleText: String {
        return item.title ?? ""
    }
    
    private var createdTimeAgoText: String? {
        guard let date = item.itemDate else {
            return nil
        }
        
        return dateFormatter.localizedString(for: date, relativeTo: Date())
    }
    
    var itemDescriptionText: String {
        var result = item.author ?? ""
        
        if !result.isEmpty, let createdTimeAgoText = self.createdTimeAgoText {
            result += " - "
            result += createdTimeAgoText
        }

        return result
    }
    
    var commentsText: String? {
        guard let commentsNumber = item.num_comments else {
            return nil
        }
        
        return commentsNumber == 1 ? "\(commentsNumber) comment" : "\(commentsNumber) comments"
    }
    
    var fullSizeImageUrl: URL? {
        guard let fullImageUrl = item.url else {
            return nil
        }
        
        return URL(string: fullImageUrl)
    }
    
    var thumbnailSizeImageUrl: URL? {
        guard let thumbnailImageUrl = item.thumbnail else {
            return nil
        }
        
        return URL(string: thumbnailImageUrl)
    }
}
