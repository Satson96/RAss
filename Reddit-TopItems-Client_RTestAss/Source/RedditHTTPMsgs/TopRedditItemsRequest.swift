//
//  TopItemsRequest.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 12.01.2021.
//

import Foundation

struct TopRedditItemsRequest: RequestProtocol {
    typealias InputType = EmptyRequestInput
    
    let baseUrl = "https://www.reddit.com/top.json"
    
    let after: String?
    let before: String?
    let limit: UInt?
    var count: UInt?
    
    var url: URL {
        var queryItems = [URLQueryItem]()
        var urlComps = URLComponents(string: baseUrl)!
        
        if let after = after {
            queryItems.append(URLQueryItem(name: "after", value: after))
        }
        
        if let before = before {
            queryItems.append(URLQueryItem(name: "before", value: before))
        }
        
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        
        if let count = count {
            queryItems.append(URLQueryItem(name: "count", value: String(count)))
        }

        urlComps.queryItems = queryItems
        return urlComps.url!
        
    }
    
}
