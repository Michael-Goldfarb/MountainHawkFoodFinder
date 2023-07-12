//
//  RathboneDetailsView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/12/23.
//

import Foundation
import SwiftUI

struct RathboneDetailsView: View {
    var body: some View {
        VStack {
            Text("Rathbone Dining Hall Details")
                .font(.title)
                .padding()
            
            // Add more content here to display the details of Rathbone Dining Hall
            
            Spacer()
        }
        .navigationBarTitle("Rathbone Dining Hall", displayMode: .inline)
    }
}

struct RathboneDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RathboneDetailsView()
    }
}
