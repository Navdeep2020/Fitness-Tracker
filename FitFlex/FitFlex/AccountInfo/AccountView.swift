//
//  AccountView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 16/03/24.
//

import SwiftUI

struct AccountView: View {
    @AppStorage("stored_user") var userEmail: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("User's Email:")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(userEmail)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("User Name:")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Navdeep Singh")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    NavigationLink(destination: FeedbackView()) {
                        Text("Send Feedback")
                    }
                    Button(action: {
                        // Perform logout action here
                    }) {
                        Text("Logout")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Account", displayMode: .large)
        }
    }
}

#Preview {
    AccountView()
}
