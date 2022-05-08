//
//  SelectDriveView.swift
//  PurpleArchive
//
//  Created by Helloyunho on 2022/04/21.
//

import SwiftUI
import DriveAPI

struct SelectDriveView: View {
    @State var loading = true
    @State var drives: [Drive] = []
    @State var selectedDrive: Drive? = nil
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
                Text("Select Drive")
                Text("Please select a drive to archive OS.")
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(drives) { drive in
                            DriveView(driveName: drive.name, selected: self.selectedDrive == drive)
                                .onTapGesture {
                                    self.selectedDrive = drive
                                }
                        }
                    }
                }
            }
        }
        .task {
            do {
                let drives = try await DriveAPI.shared.getDrives()
                self.drives = drives.drives
                self.loading = false
            } catch {
                self.error = error
                self.errorAlert = true
            }
        }
    }
}

struct SelectDriveView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDriveView()
    }
}
