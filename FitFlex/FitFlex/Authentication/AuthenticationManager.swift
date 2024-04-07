//
//  AuthenticationManager.swift
//  FitFlex
//
//  Created by Navdeep Singh on 06/04/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) { // Initialised with type User because firebase se everytime User type pe hi data ata hai return
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    func getUser() throws -> AuthDataResultModel { // no async because it checks for user in local not in server
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel { // async deals with server
       let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
