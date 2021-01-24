//
//  RedditsJSONDiskStorage.swift
//  Reddit-TopItems-Client_RTestAss
//
//  Created by Dmytro Satskyi on 21.01.2021.
//

import Foundation

class RedditsJSONDiskStorage: RedditsStorageProtocol {
    
    private let fileName = "RedditItems"
    
    var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }
    
    lazy var filelURL: URL = {
        return documentsDirectory.appendingPathComponent(fileName)
    }()
    
    func loadFromStorage() -> [RedditItem] {
        guard let codedData = try? Data(contentsOf: filelURL) else {
            return []
        }

        let decoder = JSONDecoder()
        
        guard let decodedItems = try? decoder.decode([RedditItem].self, from: codedData) else {
            return []
        }
        
        return decodedItems
    }
    
    func saveToStorage(items: [RedditItem]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            do {
                try encoded.write(to: filelURL)
            } catch {
                print("Couldn't write to save file: " + error.localizedDescription)
            }
        }
    }

}
