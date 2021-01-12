//
//  TopRedditItemsResponse.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 12.01.2021.
//

import Foundation

struct TopRedditItemsResponse: Decodable {
    
    var items: [RedditItem] = []
    var dist: Int
    var after: String?
    var before: String?
    
    enum RootKeys: CodingKey {
      case data, kind
    }
    
    enum DataKeys: CodingKey {
      case children, dist, after, before
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try rootContainer
            .nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        
        items = try dataContainer.decode([RedditItem].self, forKey: .children)
        dist = try dataContainer.decode(Int.self, forKey: .dist)
        after = try dataContainer.decode(String?.self, forKey: .after)
        before = try dataContainer.decode(String?.self, forKey: .before)
    }
}
