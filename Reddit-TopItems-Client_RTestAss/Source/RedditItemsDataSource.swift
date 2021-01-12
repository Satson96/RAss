//
//  RedditItemsDataSource.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import Foundation

class RedditItemsDataSource: NSObject {
    private let recordsPerPage = UInt(20)
    
    var count: Int = 0
    var after: String?
    var before: String?
    
    var isLoading: Bool = false
    
    func getNext(completion: @escaping (Result<[RedditItem], Error>) -> Void) {
        guard !isLoading else { return }
        
        let request = TopRedditItemsRequest(after: after,
                                            before: before,
                                            limit: recordsPerPage)
        
        isLoading = true
        HTTPNetworkClient.sharedInstance.perform(request) { (result: Result<TopRedditItemsResponse, Error>) in
            switch result {
            case .success(let response):
                let items = response.items
                
                self.count += items.count
                
                self.after = response.after
                self.before = response.before
                
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.isLoading = false
        }
    }
}
