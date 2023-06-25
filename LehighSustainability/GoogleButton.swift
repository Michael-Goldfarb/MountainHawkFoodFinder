//
//  GoogleSiginBtn.swift
//  LehighSustainability
//
//  Created by Michael Goldfarb on 6/24/23.
//

import SwiftUI

struct GoogleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .mask(
                        Circle()
                    )
            }
            
        }
        .frame(width: 50, height: 50)
    }
}

struct GoogleButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleButton(action: {})
    }
}
