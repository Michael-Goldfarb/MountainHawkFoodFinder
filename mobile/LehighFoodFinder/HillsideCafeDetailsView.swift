//
//  HillsideCafeDetailsView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/17/23.
//

import SwiftUI

struct HillsideCafeDetailsView: View {
    @State private var isHomeViewPresented = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 3) {
                Spacer()
                Spacer()
                
                Text("Hillside Cafe")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Click on the Map to Go Back to the Map")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    isHomeViewPresented = true
                }) {
                    Image("AppleMaps")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 33, height: 33)
                }
                .fullScreenCover(isPresented: $isHomeViewPresented) {
                    HomeView()
                        .environmentObject(NavigationState()) // Provide the NavigationState environment object
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
            }
            .background(Color.white)
            .navigationBarTitle("", displayMode: .inline)
            .padding(.top, -25)
            .onAppear {
            }
        }
    }
}

struct HillsideCafeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HillsideCafeDetailsView()
    }
}
