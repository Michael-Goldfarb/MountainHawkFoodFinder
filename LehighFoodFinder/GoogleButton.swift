//
//  GoogleButton.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 6/24/23.
//

import SwiftUI

struct GoogleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                
                Image("google")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                
                Text("Continue with Google")
                    .font(.system(size: 22))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: .gray, radius: 4, x: 0, y: 2)
        }
        .frame(height: 50)
    }
}

struct GoogleButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleButton(action: {})
    }
}
