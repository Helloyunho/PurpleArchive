//
//  ContentView.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/04/06.
//

import SwiftUI
import OAuth2

struct FileContent: Codable {
    var id: String
    var name: String
    var mimeType: String
    var parents: [String]
}

struct Files: Codable {
    var files: [FileContent]
}

struct ContentView: View {
    @State var loading = true
    @State var files = [String]()
    var body: some View {
        VStack {
            if loading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                ForEach(files, id: \.self) { file in
                    Text(file)
                }
            }
        }
        .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 600, maxHeight: .infinity)
        .onAppear {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "www.googleapis.com"
            components.path = "/drive/v3/files"
            components.queryItems = [
                URLQueryItem(name: "corpora", value: "drive"),
                URLQueryItem(name: "driveId", value: "0AJEGHI5tLScTUk9PVA"),
                URLQueryItem(name: "includeItemsFromAllDrives", value: "true"),
                URLQueryItem(name: "orderBy", value: "folder"),
                URLQueryItem(name: "supportsAllDrives", value: "true"),
                URLQueryItem(name: "fields", value: "files(parents, id, name, mimeType)")
            ]
            oauth2.logger = OAuth2DebugLogger(.trace)
            loader.alsoIntercept403 = true
            var req = oauth2.request(forURL: components.url!)
            req.setValue("application/json", forHTTPHeaderField: "Accept")
            loader.perform(request: req) { response in
                do {
                    let data = try response.responseData()
                    let decoded = try JSONDecoder().decode(Files.self, from: data)
                    DispatchQueue.main.async {
                        self.files = decoded.files.map({ $0.name })
                        self.loading = false
                    }
                } catch {
                    print(String(describing: error))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
