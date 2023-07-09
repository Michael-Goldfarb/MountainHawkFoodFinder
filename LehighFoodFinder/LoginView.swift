//
//  LoginView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 6/24/23.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    @State private var isLoggedIn = false
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Group {
            if isLoggedIn {
                HomeView()
            } else {
                ZStack {
                    Color(red: 0.00, green: 0.30, blue: 0.15)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 32) {
                        Text("Lehigh Food Finder")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                        
                        LoginHeader()
                            .padding(.bottom)
                        
                        GoogleButton {
                            GoogleSignInManager.shared.signIn { success in
                                isLoggedIn = success
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
