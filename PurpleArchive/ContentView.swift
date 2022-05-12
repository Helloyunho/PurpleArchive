//
//  ContentView.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/04/06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Group {
            SelectDriveView()
        }
            .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 600, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
