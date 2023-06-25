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
                Home()
            } else {

                    ZStack {
                        Color(red: 0.2, green: 0.20, blue: 0.25)
                    }
                    VStack {
                        VStack {
                            LoginHeader()
                                .padding(.bottom)
                            
                            
                            GoogleSiginBtn {
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


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

