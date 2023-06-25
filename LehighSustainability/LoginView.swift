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
                VStack {
                            VStack {
                                LoginHeader()
                                    .padding(.bottom)
                            
                                
                                GoogleSiginBtn {
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

