//
//  PurpleArchiveApp.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/04/06.
//

import SwiftUI
import OAuth2

let oauth2 = OAuth2CodeGrant(settings: [
    "client_id": "866063282978-1n2v3nnk5nfvvm4uhtai22f6nnsokl9p.apps.googleusercontent.com",
    "authorize_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://www.googleapis.com/oauth2/v3/token",
    "scope": "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/drive",
    "redirect_uris": ["com.googleusercontent.apps.866063282978-1n2v3nnk5nfvvm4uhtai22f6nnsokl9p:/oauth"],
])

let loader = OAuth2DataLoader(oauth2: oauth2)
let baseURL = URL(string: "https://www.googleapis.com/drive/v3")!

@main
struct PurpleArchiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if url.scheme == "com.googleusercontent.apps.866063282978-1n2v3nnk5nfvvm4uhtai22f6nnsokl9p" {
                        oauth2.handleRedirectURL(url)
                    }
                }
        }
    }
}
