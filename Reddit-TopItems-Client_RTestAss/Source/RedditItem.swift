//
//  RedditItem.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 12.01.2021.
//

import Foundation

struct RedditItem: Decodable {
    var title: String?
    var author: String?
    var num_comments: Int?
    var thumbnail: String?
    var url: String?
    var created: TimeInterval?
    
    enum RootKeys: CodingKey {
      case data, kind
    }
    
    enum CodingKeys: CodingKey {
      case title, author, num_comments, thumbnail, url, created
    }
    
    var itemDate: Date? {
        guard let created = created else {
            return nil
        }
        
        return Date(timeIntervalSince1970: created)
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try rootContainer
            .nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        title = try dataContainer.decode(String?.self, forKey: .title)
        author = try dataContainer.decode(String?.self, forKey: .author)
        num_comments = try dataContainer.decode(Int?.self, forKey: .num_comments)
        thumbnail = try dataContainer.decode(String?.self, forKey: .thumbnail)
        url = try dataContainer.decode(String?.self, forKey: .url)
        created = try dataContainer.decode(TimeInterval?.self, forKey: .created)
    }
    
}
