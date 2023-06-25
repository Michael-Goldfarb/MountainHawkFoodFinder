//
//  LoginHeader.swift
//  LehighSustainability
//
//  Created by Michael Goldfarb on 6/24/23.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    @State private var isLoggedIn = false
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        Group {
            if isLoggedIn {
                HomeView()
            } else {
                
                ZStack {
                    Color(red: 0.00, green: 0.30, blue: 0.15)
                    VStack {
                        VStack {
                            Text("Lehigh Sustainability!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            LoginHeader()
                                .padding(.bottom)
                            
                            
                            GoogleButton {
                                GoogleSignInManager.shared.signIn { success in
                                    isLoggedIn = success
                                }
                            }
                        } // GoogleSiginBtn
                    } // VStack
                    .padding(.top, 52)
                    Spacer()
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
