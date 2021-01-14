//
//  NetworkImageOperation.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 13.01.2021.
//

import UIKit

class NetworkImageOperation: AsyncOperation {
    var image: UIImage?
    
    typealias CompletionHandler = ((UIImage?) -> Void)

    private let url: URL
    private let completionHandler: CompletionHandler?
    private var task: URLSessionDataTask?

    init(url: URL, completionHandler: CompletionHandler? = nil) {
        self.url = url
        self.completionHandler = completionHandler

        super.init()
    }

    override func main() {
        
        #if DEBUG
        print("NetworkImageOperation: start loading image at url \(url.absoluteString)")
        #endif
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30.0)
        
        task = URLSession.shared.dataTask(with: request) { [weak self]
            data, response, error in

            guard let self = self else { return }

            defer {
                #if DEBUG
                print("NetworkImageOperation: finish loading image at url \(self.url.absoluteString)")
                #endif
                
                self.completionHandler?(self.image)
                self.state = .finished
            }

            guard !self.isCancelled else { return }

            guard error == nil, let data = data else {
                return
            }

            self.image = UIImage(data: data)
        }

        task?.resume()
    }

    override func cancel() {
        super.cancel()
        task?.cancel()
    }

}
