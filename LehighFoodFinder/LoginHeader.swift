//
//  LoginHeader.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 6/24/23.
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        VStack {
            Text("Welcome to Lehigh Food Finder")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
    }
}

struct LoginHeader_Previews: PreviewProvider {
    static var previews: some View {
        LoginHeader()
    }
}
