//
//  HomeViewModel.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 6/10/23.
//

import SwiftUI
import MapKit

class NavigationState: ObservableObject {
    @Published var isButtonClicked = false
    
    func navigateToRathboneDetails() {
        isButtonClicked = true
    }
}

struct MapBackgroundView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @EnvironmentObject var navigationState: NavigationState
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        
        let lehighUniversityCoordinate = CLLocationCoordinate2D(latitude: 40.6074, longitude: -75.3766)
        let region = MKCoordinateRegion(center: lehighUniversityCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(region, animated: false)
        
        // Add annotations
        let rathboneAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.606703, longitude: -75.372916), title: "Rathbone Dining Hall")
        mapView.addAnnotation(rathboneAnnotation)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Perform any necessary updates to the map view
        // You can configure the map view properties, add annotations, etc.
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var mapBackgroundView: MapBackgroundView
        
        init(_ mapBackgroundView: MapBackgroundView) {
            self.mapBackgroundView = mapBackgroundView
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? CustomAnnotation else {
                return nil
            }
            
            let identifier = "CustomAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let annotation = view.annotation as? CustomAnnotation {
                if annotation.title == "Rathbone Dining Hall" {
                    print("We almost there")
                    mapBackgroundView.navigationState.navigateToRathboneDetails()
                }
            }
        }
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}

class NavigationManager {
    static let shared = NavigationManager()
    
    private init() {}
    
    func navigateToRathboneDetails() {
        // Perform navigation to RathboneDetailsView
        // You can replace this with your desired navigation method
        print("Navigating to RathboneDetailsView")
    }
}

struct HomeView: View {
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        NavigationView {
            ZStack {
                if !navigationState.isButtonClicked { // Only display MapBackgroundView if isButtonClicked is false
                    MapBackgroundView()
                        .edgesIgnoringSafeArea(.all)
                }
                
                if navigationState.isButtonClicked {
                    RathboneDetailsView()
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationState()) // Provide the NavigationState environment object
    }
}
