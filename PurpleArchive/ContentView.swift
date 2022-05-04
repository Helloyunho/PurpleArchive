//
//  ContentView.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/04/06.
//

import SwiftUI
import DriveAPI

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
