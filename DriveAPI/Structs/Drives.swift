//
//  Drives.swift
//  DriveAPI
//
//  Created by Helloyunho on 2022/05/04.
//

import Foundation

public struct Drives: Codable {
    public let id: String
    public let name: String
}

public struct DrivesPayload: Codable {
    public let drives: Drives
}
