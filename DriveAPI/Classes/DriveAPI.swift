//
//  DriveAPI.swift
//  DriveAPI
//
//  Created by Helloyunho on 2022/04/22.
//

import Foundation
import OAuth2

public class DriveAPI {
    let oauth2: OAuth2CodeGrant
    let loader: OAuth2DataLoader
    
    static public var shared = DriveAPI()
    
    public convenience init() {
        self.init(oauth2: OAuth2CodeGrant(settings: [
            "client_id": "866063282978-1n2v3nnk5nfvvm4uhtai22f6nnsokl9p.apps.googleusercontent.com",
            "authorize_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://www.googleapis.com/oauth2/v3/token",
            "scope": "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/drive",
            "redirect_uris": ["com.googleusercontent.apps.866063282978-1n2v3nnk5nfvvm4uhtai22f6nnsokl9p:/oauth"],
        ]))
    }
    
    public init(oauth2: OAuth2CodeGrant) {
        self.oauth2 = oauth2
        self.loader = OAuth2DataLoader(oauth2: oauth2)
        self.loader.alsoIntercept403 = true
        self.oauth2.logger = OAuth2DebugLogger(.trace)
    }

    public func structURL(path: String, querys: [URLQueryItem] = []) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/drive/v3" + path
        components.queryItems = querys
        return components.url!
    }
    
    public func send<D>(url: URL, decoder: D.Type? = nil) async throws -> D? where D: Decodable {
        var req = oauth2.request(forURL: url)
        if decoder != nil {
            req.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        return try await withCheckedThrowingContinuation { continuation in
            loader.perform(request: req) { response in
                do {
                    let data = try response.responseData()
                    if let decoder = decoder {
                        let decoded = try JSONDecoder().decode(decoder, from: data)
                        continuation.resume(returning: decoded)
                    } else {
                        continuation.resume(returning: nil)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func handleURL(_ url: URL) {
        self.oauth2.handleRedirectURL(url)
    }
    
    public func getDrives() async throws -> Drives {
        let url = DriveAPI.shared.structURL(path: "/drives")
        let result = try await DriveAPI.shared.send(url: url, decoder: Drives.self)!
        return result
    }
    
    public func getFiles(_ driveID: String, parent: String? = nil) async throws -> Files {
        let url = DriveAPI.shared.structURL(path: "/files", querys: [
            URLQueryItem(name: "corpora", value: "drive"),
            URLQueryItem(name: "driveId", value: driveID),
            URLQueryItem(name: "includeItemsFromAllDrives", value: "true"),
            URLQueryItem(name: "orderBy", value: "folder,name"),
            URLQueryItem(name: "supportsAllDrives", value: "true"),
            URLQueryItem(name: "fields", value: "files(parents, id, name, mimeType)"),
            URLQueryItem(name: "q", value: "'\(parent ?? driveID)' in  parents")
        ])
        let result = try await DriveAPI.shared.send(url: url, decoder: Files.self)!
        return result
    }
}
