//
//  HTTPNetworkClient.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import Foundation

class HTTPNetworkClient: NSObject {
    static let sharedInstance = HTTPNetworkClient()
    
    private let serialParseQueue = DispatchQueue(label: "raketa.test.queue")
    
    private lazy var generalError: NSError = {
        return NSError(domain: "HTTPNetworkClient",
                       code: 0,
                       userInfo: [NSLocalizedDescriptionKey: "Something went wrong.\nPlease try later again."])
    }()
    
    private var acceptableStatusCodes: Range<Int> { return 200..<300 }
    
    func perform<Request: RequestProtocol, Response: Decodable>(_ request: Request, completion: @escaping (Result<Response, Error>) -> Void) {
            
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let input = request.input {
            do {
                let data = try JSONEncoder().encode(input)
                urlRequest.httpBody = data
            } catch {
                fatalError("HTTPNetworkClient: encode http request input error. \(error.localizedDescription)")
            }
        }
        
        #if DEBUG
        print("HTTPNetworkClient: Sending Request : " + urlRequest.url!.absoluteString)
        #endif
        
        let session = URLSession.shared
        let sessionTask = session.dataTask(with: urlRequest) { data, response, error in
            self.serialParseQueue.async {
                let statusCode = (response as! HTTPURLResponse).statusCode
                guard let data = data, error == nil, self.acceptableStatusCodes.contains(statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(self.generalError))
                    }
                    return
                }
                
                #if DEBUG
                let jsonResult = try! JSONSerialization.jsonObject(with: data, options: [])
                print("HTTPNetworkClient: Response Data: \(jsonResult)")
                print("HTTPNetworkClient: Response Status code: \(statusCode)")
                #endif
                
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                    
                } catch let error as NSError {
                    print("HTTPNetworkClient: decode http response error. \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        completion(.failure(self.generalError))
                    }
                    
                }
            }
        }
        sessionTask.resume()
    }
}
