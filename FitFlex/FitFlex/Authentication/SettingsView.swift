//
//  SettingsView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 07/04/24.
//

import SwiftUI

final class SettingsViewModel : ObservableObject {
    
    
    func logOut() throws {
       try AuthenticationManager.shared.signOut()
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel() //Initialized here
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            Button(action: {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print("Error \(error)")
                    }
                }
            }, label: {
                Text("Log out")
            })
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(showSignInView: .constant(true))
}
