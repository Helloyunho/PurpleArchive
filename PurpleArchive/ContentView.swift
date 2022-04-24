//
//  ContentView.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/04/06.
//

import SwiftUI
import DriveAPI

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
    @State var error: Error? = nil
    @State var errorAlert = false
    var body: some View {
        VStack {
            if loading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .alert(Text("Error"), isPresented: $errorAlert) {
                        Button("OK") {}
                    } message: {
                        Text(error?.localizedDescription ?? "")
                    }
            } else {
                ForEach(files, id: \.self) { file in
                    Text(file)
                }
            }
        }
        .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 600, maxHeight: .infinity)
        .task {
            do {
                let url = Drive.shared.structURL(path: "/files", querys: [
                    URLQueryItem(name: "corpora", value: "drive"),
                    URLQueryItem(name: "driveId", value: "0AJEGHI5tLScTUk9PVA"),
                    URLQueryItem(name: "includeItemsFromAllDrives", value: "true"),
                    URLQueryItem(name: "orderBy", value: "folder,name"),
                    URLQueryItem(name: "supportsAllDrives", value: "true"),
                    URLQueryItem(name: "fields", value: "files(parents, id, name, mimeType)"),
                    URLQueryItem(name: "q", value: "'0AJEGHI5tLScTUk9PVA' in  parents")
                ])
                let result = try await Drive.shared.send(url: url, decoder: Files.self)!
                self.files = result.files.map({ $0.name })
                self.loading = false
            } catch {
                self.error = error
                self.errorAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
