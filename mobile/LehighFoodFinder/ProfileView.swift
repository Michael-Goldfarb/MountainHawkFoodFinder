//
//  ProfileView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/19/23.
//

import SwiftUI

struct ProfileView: View {
    let userEmail = GoogleSignInManager.shared.userEmail ?? ""
    let userName = GoogleSignInManager.shared.userName ?? ""

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.05)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack {
                    if userName != "" && userEmail != "" {
                        Text("User Information:")
                            .font(.headline)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text("Name: \(userName)")
                            .foregroundColor(.white)

                        Text("Email: \(userEmail)")
                            .foregroundColor(.white)
                    } else {
                        Text("Loading...")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            // Print the values of userName and userEmail when the view appears
            print("userName:", userName)
            print("userEmail:", userEmail)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
