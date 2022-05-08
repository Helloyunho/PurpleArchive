//
//  DriveView.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/05/05.
//

import SwiftUI

struct DriveView: View {
    var driveName: String
    var selected: Bool
    
    var body: some View {
        VStack {
            Text(driveName)
            Image(systemName: "externaldrive.connected.to.line.below.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .padding()
        }
        .frame(width: 160, height: 160)
        .padding()
        .overlay(Group {
            if selected {
                RoundedRectangle(cornerRadius: 24).foregroundColor(.secondary).opacity(0.2)
            } else {
                EmptyView()
            }
        })
    }
}


struct DriveViewPreviewWrapper: View {
    var selected = true
    var body: some View {
        DriveView(driveName: "DriveName", selected: selected)
    }
}
struct DriveView_Previews: PreviewProvider {
    static var previews: some View {
        DriveViewPreviewWrapper()
    }
}
