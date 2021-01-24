//
//  RedditItem.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 12.01.2021.
//

import Foundation

struct RedditItem: Codable {
    var title: String?
    var author: String?
    var num_comments: Int?
    var thumbnail: String?
    var url: String?
    var created: TimeInterval?
    var preview: ImagePreview?
    
    var itemDate: Date? {
        guard let created = created else {
            return nil
        }
        
        return Date(timeIntervalSince1970: created)
    }
    
    enum RootKeys: CodingKey {
      case data, kind
    }
    
    enum CodingKeys: CodingKey {
      case title, author, num_comments, thumbnail, url, created_utc, preview
    }
    
    enum PreviewKeys: CodingKey {
      case images
    }
    
    
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.self,
                                                              forKey: .data)
        
        title = try? dataContainer.decode(String?.self, forKey: .title)
        author = try? dataContainer.decode(String?.self, forKey: .author)
        num_comments = try? dataContainer.decode(Int?.self, forKey: .num_comments)
        thumbnail = try? dataContainer.decode(String?.self, forKey: .thumbnail)
        url = try? dataContainer.decode(String?.self, forKey: .url)
        created = try? dataContainer.decode(TimeInterval?.self, forKey: .created_utc)
        
        let previewContainer = try? dataContainer.nestedContainer(keyedBy: PreviewKeys.self,
                                                                  forKey: .preview)
        
        preview = (try? previewContainer?.decode([RedditItem.ImagePreview]?.self, forKey: .images))?.first
        
    }
    
    func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: RootKeys.self)
        var dataContainer = rootContainer.nestedContainer(keyedBy: CodingKeys.self,
                                                          forKey: .data)
        
        try dataContainer.encode(self.title, forKey: .title)
        try dataContainer.encode(self.author, forKey: .author)
        try dataContainer.encode(self.num_comments, forKey: .num_comments)
        try dataContainer.encode(self.thumbnail, forKey: .thumbnail)
        try dataContainer.encode(self.url, forKey: .url)
        try dataContainer.encode(self.created, forKey: .created_utc)
        
        if let preview = self.preview {
            var previewContainer = dataContainer.nestedContainer(keyedBy: PreviewKeys.self,
                                                                 forKey: .preview)

            try previewContainer.encode([preview], forKey: .images)
        }
        
        
    }
    
}

extension RedditItem {
    struct ImageSource: Codable {
        var imageUrlStr: String?
        
        enum CodingKeys: CodingKey {
          case url
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let urlStr = try? container.decode(String?.self, forKey: .url)
            
            // the image url string is received as html encoded. since url is signed, we need it in original format(decoded back) to have valid url.
            // for the image url string only '&' character is encoded.
            imageUrlStr = urlStr?.replacingOccurrences(of: "&amp;", with: "&")
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.imageUrlStr, forKey: .url)
        }
    }
    
    struct ImagePreview: Codable {
        var id: String?
        var source: ImageSource
    }
}
