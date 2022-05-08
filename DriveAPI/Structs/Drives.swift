//
//  Drives.swift
//  DriveAPI
//
//  Created by Helloyunho on 2022/05/04.
//

import Foundation

public struct Drive: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
}

public struct Drives: Codable {
    public let drives: [Drive]
}
