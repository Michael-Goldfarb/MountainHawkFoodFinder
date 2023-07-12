//
//  HomeViewModel.swift
//  LehighFoodFinder
//
//  Created by Michael Goldfarb on 6/10/23.
//


import SwiftUI
import MapKit

struct MapBackgroundView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        
        let lehighUniversityCoordinate = CLLocationCoordinate2D(latitude: 40.6074, longitude: -75.3766)
        let region = MKCoordinateRegion(center: lehighUniversityCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(region, animated: false)
        
        // Add annotations
        let rathboneAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.606703, longitude: -75.372916),  title: "Rathbone Dining Hall")
        mapView.addAnnotation(rathboneAnnotation)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Perform any necessary updates to the map view
        // You can configure the map view properties, add annotations, etc.
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            // Handle annotation selection here
            if let annotation = view.annotation as? CustomAnnotation {
                if annotation.title == "Rathbone Dining Hall" {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        let rathboneDetailsView = RathboneDetailsView()
                        let hostingController = UIHostingController(rootView: rathboneDetailsView)
                        
                        // Push the UIHostingController onto the navigation stack
                        if let navigationController = window.rootViewController as? UINavigationController {
                            navigationController.pushViewController(hostingController, animated: true)
                        }
                    }
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



struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                MapBackgroundView() // Use the custom map view as the background
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



struct User: Codable {
    let name: String?
    let email: String
}
//
//struct HomeView_Previews: PreviewProvider {
//  static var previews: some View {
//    NavigationStack {
//      HomeView()
//    }
//  }
//}

//struct User: Codable {
//    let name: String?
//    let email: String
//}
