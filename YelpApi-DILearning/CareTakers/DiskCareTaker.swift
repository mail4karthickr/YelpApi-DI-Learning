//
//  DiskCareTaker.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 7/4/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation

public final class DiskCareTaker {
    func save<T: Codable>(object: T, fileName: String) throws {
        do {
            let url = createDocumentURL(withFileName: fileName)
            let data = try JSONEncoder().encode(object)
            try data.write(to: url, options: .atomic)
        } catch {
            throw error
        }
    }
    
    func retrieve<T: Codable>(type: T.Type, fileName: String) throws -> T {
        do {
            let url = createDocumentURL(withFileName: fileName)
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
    
    func retrieve<T: Codable>(type: T.Type, fromURL url: URL) throws -> T {
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw error
        }
    }
    
    private func createDocumentURL(withFileName fileName: String) -> URL {
        return documentDirectoryURL.appendingPathComponent(fileName).appendingPathExtension("json")
    }
    
    var documentDirectoryURL: URL {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func contentsOfDocumentDirectory() throws -> [URL] {
        let fileManager = FileManager.default
        return try fileManager.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    }
}
