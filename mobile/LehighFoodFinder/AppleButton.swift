//
//  AppleButton.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 6/24/23.
//

import SwiftUI

struct AppleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 2) {
                Spacer()
                
                Image("apple")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 53, height: 53)
                
                Text("Continue with Apple")
                    .font(.system(size: 22.5))
                    .foregroundColor(.white)
                    .padding(.leading, -4)
                
                Spacer()
            }
            .padding(2.5)
            .background(Color.black)
            .cornerRadius(25)
            .shadow(color: .black, radius: 4, x: 0, y: 2)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity) // Center the button horizontally
    }
}



struct AppleButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleButton(action: {})
    }
}