//
//  RedditItemsViewModel.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import Foundation

class RedditItemsViewModel: NSObject {
    
    private var redditItems: [RedditItem] = []
    
    private let dataSource = RedditItemsDataSource()
    
    weak var delegate: ViewModelDelegate?
    
    func loadNextPage() {
        self.delegate?.willLoadData()
        dataSource.getNext { (result: Result<[RedditItem], Error>) in
            switch result {
            case .success(let items):
                self.redditItems.append(contentsOf: items)
                self.delegate?.didLoadData()
            case .failure(let error):
                self.delegate?.receivedError(message: error.localizedDescription)
            }
        }
    }
    
    func getNumberOfItems() -> Int {
        return redditItems.count
    }
    
    func getViewModel(forIndex index: Int) -> RedditItemViewModel {
        return RedditItemViewModel(item: redditItems[index])
    }
    
    func canLoadNextPage() -> Bool {
        return dataSource.hasNextPage() && !dataSource.isLoading
    }
}
