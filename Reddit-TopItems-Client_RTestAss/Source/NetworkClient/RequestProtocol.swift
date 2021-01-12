//
//  RequestProtocol.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 12.01.2021.
//

import Foundation

enum HttpMethodType: String {
    case POST
    case GET
    case DELETE
    case PUT
}

protocol RequestProtocol {
    associatedtype InputType: RequestInputProtocol
    var url: URL { get }
    var method: HttpMethodType { get }
    var input: InputType? { get }

}

extension RequestProtocol {
    var input: InputType? { return nil }
    
    var method: HttpMethodType {
        return HttpMethodType.GET
    }

}
