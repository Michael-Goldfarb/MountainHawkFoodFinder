//
//  LoginHeader.swift
//  LehighSustainability
//
//  Created by Michael Goldfarb on 6/24/23.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        ZStack {
            Color(red: 0.00, green: 0.30, blue: 0.15)
            VStack {
                Text("Login to enter the app!")
                    .font(.title)
                    .fontWeight(.medium)
                    .padding()
                
                
            }
        }
    }
}

struct LoginHeader_Previews: PreviewProvider {
    static var previews: some View {
        LoginHeader()
    }
}
