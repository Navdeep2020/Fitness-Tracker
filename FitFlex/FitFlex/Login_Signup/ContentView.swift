//
//  ContentView.swift
//  FitFlex
//
//  Created by Navdeep Singh on 10/03/24.
//

import SwiftUI
import CoreData
import LocalAuthentication

struct ContentView: View {
    
    @State var email: String
    @State var password: String
    
    // First time ko store krne k liye
    @AppStorage("stored_user") var user = "9706339070nav@gmail.com"
    @AppStorage("status") var logged = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black.opacity(0.89)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 0)
                Text("FitFlex")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                    
                
                Text("Welcome Back!")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                HStack {
                    
                    Image(systemName: "envelope")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 35)
                    
                    TextField("Email", text: $email)
                        .bold()
                        .autocorrectionDisabled()
                    
                }
                .padding()
                .background(Color.white.opacity(email == "" ? 0.1 : 0.5))
                .cornerRadius(15)
                .padding(.horizontal)
                
                HStack {
                    
                    Image(systemName: "lock")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 35)
                    
                    SecureField("Password", text: $password)
                        .bold()
                        .autocorrectionDisabled()
                    
                }
                .padding()
                .background(Color.white.opacity(password == "" ? 0.1 : 0.5))
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.top)
                
                HStack(spacing: 15) {
                    Button("Login") {
                        
                    }
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(
                    RoundedRectangle(cornerRadius: 10)
                    
                    )
                    .cornerRadius(10)
                    .opacity(email != "" && password != "" ? 1 : 0.5)
                    .disabled(email != "" && password != "" ? false : true)
                    
                    if getBiometric() {
                        Button(action: {
                            authenticateUser()
                        }, label: {
                            (Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid"))
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .clipShape(Circle())
                             //   .background(Color("green"))
                             
                        })
                    }
                }
                .padding(.top)
                //Forgot Button
                
                Button("Forgot password") {
                    
                }.foregroundColor(.blue)
                    .font(.headline)
                    .padding(.top,8)
                
                // Signup
                Spacer(minLength: 0)
                
                HStack(spacing: 5) {
                    Text("Don't have an account ? ")
                        .foregroundColor(Color.white.opacity(0.6))
                    
                    Button("Signup") {
                        
                    }
                    .foregroundColor( Color.purple.opacity(0.8))
                    .fontWeight(.heavy)
                }
                .padding(.vertical)
            }
            .animation(.easeOut)
        }
    }
    
    // Getting biometric type
    func getBiometric() -> Bool {
        let scanner = LAContext()
        if email == user && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
            return true
        }
        return false
    }
    
    // authrnticate user
    func authenticateUser() {
        let scanner = LAContext()
        
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To unlock \(user)") { (status,error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            withAnimation(.easeOut){logged = true}
        }
    }
}

#Preview {
    ContentView(email: "", password: "")
}
