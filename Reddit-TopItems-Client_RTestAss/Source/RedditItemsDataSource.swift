//
//  RedditItemsDataSource.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import UIKit

class RedditItemsDataSource: NSObject {
    private let recordsPerPage = UInt(20)
    
    var redditItems: [RedditItem] = []
    
    fileprivate var persistentStorage: RedditsStorageProtocol! {
        didSet {
            self.redditItems = persistentStorage.loadFromStorage()
        }
    }
    
    fileprivate var count: Int = 0
    fileprivate var after: String?
    fileprivate var before: String?
    fileprivate var lastDist: Int?

    fileprivate var clearDataSourceOnNextSuccess = false
    
    var isLoading: Bool = false
    
    init(persistentStorage: RedditsStorageProtocol) {
        self.persistentStorage = persistentStorage
        super.init()
        
        addAppStateObservers()
    }
    
    
    required init?(coder: NSCoder) {
        count = coder.decodeInteger(forKey: RedditItemsDataSource.countKey)
        after = coder.decodeObject(forKey: RedditItemsDataSource.afterKey) as? String
        before = coder.decodeObject(forKey: RedditItemsDataSource.beforeKey) as? String
        lastDist = (coder.decodeObject(forKey: RedditItemsDataSource.lastDistKey) as? NSNumber)?.intValue
        
        super.init()
        
        addAppStateObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addAppStateObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillResignActiveNotification),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackgroundNotification),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc func appWillResignActiveNotification() {
        persistentStorage.saveToStorage(items: redditItems)
    }
    
    @objc func appDidEnterBackgroundNotification() {
        persistentStorage.saveToStorage(items: redditItems)
    }
    
    func set(persistentStorage: RedditsStorageProtocol) {
        self.persistentStorage = persistentStorage
    }
    
    func getNext(completion: @escaping (Result<[RedditItem], Error>) -> Void) {
        guard !isLoading else { return }
        
        let request = TopRedditItemsRequest(after: after,
                                            before: before,
                                            limit: recordsPerPage)
//                                            count: count != 0 ? UInt(count) : nil)
        
        isLoading = true
        HTTPNetworkClient.sharedInstance.perform(request) { [weak self] (result: Result<TopRedditItemsResponse, Error>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let response):
                let items = response.items
                
                self.count += response.dist
                
                self.after = response.after
                self.before = response.before
                
                self.lastDist = response.dist
                
                if self.clearDataSourceOnNextSuccess {
                    self.clearDataSourceOnNextSuccess = false
                    self.redditItems.removeAll()
                }
                
                self.redditItems.append(contentsOf: items)
                
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self.isLoading = false
        }
    }
    
    func hasNextPage() -> Bool {
        let lastPageReceived = lastDist == 0 && after == nil
        return !lastPageReceived
    }
    
    func resetPagination() {
        count    = 0
        after    = nil
        before   = nil
        lastDist = nil
        clearDataSourceOnNextSuccess = true
    }
}

extension RedditItemsDataSource: NSSecureCoding {
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    static var countKey = "count"
    static var afterKey = "after"
    static var beforeKey = "before"
    static var lastDistKey = "lastDist"
    
    func encode(with coder: NSCoder) {
        coder.encode(count, forKey: RedditItemsDataSource.countKey)
        coder.encode(after, forKey: RedditItemsDataSource.afterKey)
        coder.encode(before, forKey: RedditItemsDataSource.beforeKey)
         
        let lastDistNumber: NSNumber? = lastDist != nil ? NSNumber(integerLiteral: lastDist!) : nil
        coder.encode(lastDistNumber, forKey: RedditItemsDataSource.lastDistKey)
    }
    
    
}
