//
//  PurpleArchiveApp.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/04/06.
//

import SwiftUI
import DriveAPI

@main
struct PurpleArchiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if url.scheme == "com.googleusercontent.apps.866063282978-1n2v3nnk5nfvvm4uhtai22f6nnsokl9p" {
                        DriveAPI.shared.handleURL(url)
                    }
                }
        }
    }
}
