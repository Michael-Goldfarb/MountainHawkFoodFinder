//
//  RathboneDetailsView.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 7/12/23.
//

import SwiftUI
import MapKit

struct RathboneDetailsView: View {
    let rathboneCoordinate = CLLocationCoordinate2D(latitude: 40.606703, longitude: -75.372916)
    
    var body: some View {
        VStack {
            Text("Rathbone Dining Hall Details")
                .font(.title)
                .padding()
            
            MapView(coordinate: rathboneCoordinate)
                .frame(height: 200)
                .cornerRadius(10)
                .padding()
            
            // Add more content here to display the details of Rathbone Dining Hall
            
            Spacer()
        }
        .navigationBarTitle("Rathbone Dining Hall", displayMode: .inline)
    }
}

struct MapView: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}

struct RathboneDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RathboneDetailsView()
    }
}
