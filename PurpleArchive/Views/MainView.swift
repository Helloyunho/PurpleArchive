//
//  MainView.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/05/09.
//

import SwiftUI
import DriveAPI

struct MainView: View {
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
        .task {
            do {
                let result = try await DriveAPI.shared.getFiles("0AJEGHI5tLScTUk9PVA")
                self.files = result.files.map({ $0.name })
                self.loading = false
            } catch {
                self.error = error
                self.errorAlert = true
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
