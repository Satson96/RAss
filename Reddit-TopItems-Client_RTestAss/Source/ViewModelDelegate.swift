//
//  ViewModelDelegate.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 11.01.2021.
//

import Foundation

protocol ViewModelDelegate: class {
    func receivedError(message: String)
    
    func willLoadData()
    func didLoadData()
}
