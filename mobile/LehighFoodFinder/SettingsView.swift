//
//  SettingsView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/19/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var navigateToLogin = false
    @ObservedObject var signInManager = GoogleSignInManager.shared
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.05)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Button(action: {
                    GoogleSignInManager.shared.signOut { success in
                        if success {
                            navigateToLogin = true
                        }
                    }
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                
                // Add additional settings
                
            }
            .padding()
            .fullScreenCover(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
