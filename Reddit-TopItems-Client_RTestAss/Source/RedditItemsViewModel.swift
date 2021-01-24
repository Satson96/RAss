//
//  RedditItemsViewModel.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import Foundation

class RedditItemsViewModel: NSObject {
    
    private var dataSource = RedditItemsDataSource(persistentStorage: RedditsJSONDiskStorage())
    
    weak var delegate: ViewModelDelegate?
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        let storage = RedditsJSONDiskStorage()
        dataSource = coder.decodeObject(of: RedditItemsDataSource.self,
                                        forKey: RedditItemsViewModel.redditDataSourceKey) ?? RedditItemsDataSource(persistentStorage: storage)
        dataSource.set(persistentStorage: storage)
    }
    
    func loadNextPage() {
        self.delegate?.willLoadData()
        dataSource.getNext { (result: Result<[RedditItem], Error>) in
            switch result {
            case .success(_):
                self.delegate?.didLoadData()
            case .failure(let error):
                self.delegate?.receivedError(message: error.localizedDescription)
            }
        }
    }
    
    func getNumberOfItems() -> Int {
        return dataSource.redditItems.count
    }
    
    func getViewModel(forIndex index: Int) -> RedditItemViewModel {
        return RedditItemViewModel(item: dataSource.redditItems[index])
    }
    
    func canLoadNextPage() -> Bool {
        return dataSource.hasNextPage() && !dataSource.isLoading
    }
    
    func refreshPages() {
        dataSource.resetPagination()
        loadNextPage()
    }
    
    func getUIModelAssociationDataSnapshot() -> [String?] {
        return dataSource.redditItems.map({ $0.url })
    }
}

extension RedditItemsViewModel: NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        return true
    }

    static var redditDataSourceKey = "redditItemsDataSource"

    func encode(with coder: NSCoder) {
        coder.encode(self.dataSource, forKey: RedditItemsViewModel.redditDataSourceKey)
    }

}
