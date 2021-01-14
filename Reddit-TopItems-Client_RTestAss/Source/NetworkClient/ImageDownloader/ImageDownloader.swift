//
//  ImageDownloader.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 13.01.2021.
//

import UIKit

class ImageDownloader: NSObject {
    static let sharedInstance = ImageDownloader()
    
    private lazy var imageDownloaderOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    private var cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100
        return cache
    }()

    func loadImage(url: URL, completion: @escaping (UIImage?, URL?, Bool)->()) {
        
        let cachedImage = cache.object(forKey: url as NSURL)
        if let image = cachedImage {
            completion(image, url, true)
            print("ImageDownloader: getting from cache.")
            return
        }
        
        let networkImageOperation = NetworkImageOperation(url: url) { (image) in
            if let image = image {
                self.cache.setObject(image, forKey: url as NSURL)
                print("ImageDownloader: setting to cache.")
            }

            DispatchQueue.main.async {
                completion(image, url, false)
            }
        }
        
        imageDownloaderOperationQueue.addOperation(networkImageOperation)
    }
    

}
