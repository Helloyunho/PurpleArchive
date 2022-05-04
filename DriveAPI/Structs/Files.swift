//
//  Files.swift
//  DriveAPI
//
//  Created by Helloyunho on 2022/05/04.
//

import Foundation

public struct FileContent: Codable {
    public let id: String
    public let name: String
    public let mimeType: String
    public let parents: [String]
}

public struct Files: Codable {
    public let files: [FileContent]
}
