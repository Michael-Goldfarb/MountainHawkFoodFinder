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
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.43, green: 0.27, blue: 0.14), Color(red: 0.29, green: 0.18, blue: 0.09)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                Text("Welcome to Lehigh Food Finder")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("A place to find, rate, and enjoy Lehigh's eatery options!")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                GoogleButton {
                    GoogleSignInManager.shared.signIn { success in
                        isLoggedIn = success
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
