//
//  RedditsStorageProtocol.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 21.01.2021.
//

import Foundation

protocol RedditsStorageProtocol {
    func loadFromStorage() -> [RedditItem]
    func saveToStorage(items: [RedditItem])
}
