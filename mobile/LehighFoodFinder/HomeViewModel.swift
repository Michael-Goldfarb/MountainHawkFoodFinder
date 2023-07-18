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
    @Published var selectedLocation = ""
    
    func navigateToRathboneDetails() {
        selectedLocation = "Rathbone Dining Hall"
        isButtonClicked = true
    }
    
    func navigateToHawksNestOptions() {
        selectedLocation = "Hawk's Nest"
        isButtonClicked = true
    }
    
    func navigateToTheGrindOptions() {
        selectedLocation = "The Grind @ FML"
        isButtonClicked = true
    }
    
    func navigateToCommonGroundsOptions() {
        selectedLocation = "Common Grounds"
        isButtonClicked = true
    }
    
    func navigateToHideawayCafeOptions() {
        selectedLocation = "The Hideaway Cafe"
        isButtonClicked = true
    }
    
    func navigateToLucysCafeOptions() {
        selectedLocation = "Lucy's Café"
        isButtonClicked = true
    }
    
    func navigateToHillsideCafeOptions() {
        selectedLocation = "Hillside Cafe"
        isButtonClicked = true
    }
    
    func navigateToGlobalCafeOptions() {
        selectedLocation = "Global Cafe"
        isButtonClicked = true
    }
    
    func navigateToIacoccaCafeOptions() {
        selectedLocation = "Iacocca Café"
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
        
        let hawksNestAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.605568, longitude: -75.376236), title: "Hawk's Nest")
        mapView.addAnnotation(hawksNestAnnotation)
        
        let grindAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.609062, longitude: -75.378034), title: "The Grind @ FML")
        mapView.addAnnotation(grindAnnotation)
        
        let commonGroundsAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.608202, longitude: -75.373936), title: "Common Grounds")
        mapView.addAnnotation(commonGroundsAnnotation)
        
        let hideawayCafeAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.60946, longitude: -75.37688), title: "The Hideaway Cafe")
        mapView.addAnnotation(hideawayCafeAnnotation)
        
        let lucysCafeAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.606701, longitude: -75.376968), title: "Lucy's Café")
        mapView.addAnnotation(lucysCafeAnnotation)
        
        let hillsideCafeAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.60456, longitude: -75.3797), title: "Hillside Cafe")
        mapView.addAnnotation(hillsideCafeAnnotation)
        
        let globalCafeAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.606739, longitude: -75.37563), title: "Global Cafe")
        mapView.addAnnotation(globalCafeAnnotation)
        
        let iacoccaCafeAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.601456, longitude: -75.359968), title: "Iacocca Café")
        mapView.addAnnotation(iacoccaCafeAnnotation)
        
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
                    mapBackgroundView.navigationState.navigateToRathboneDetails()
                } else if annotation.title == "Hawk's Nest" {
                    mapBackgroundView.navigationState.navigateToHawksNestOptions()
                } else if annotation.title == "The Grind @ FML" {
                    mapBackgroundView.navigationState.navigateToTheGrindOptions()
                } else if annotation.title == "Common Grounds" {
                    mapBackgroundView.navigationState.navigateToCommonGroundsOptions()
                } else if annotation.title == "The Hideaway Cafe" {
                    mapBackgroundView.navigationState.navigateToHideawayCafeOptions()
                } else if annotation.title == "Lucy's Café" {
                    mapBackgroundView.navigationState.navigateToLucysCafeOptions()
                } else if annotation.title == "Hillside Cafe" {
                    mapBackgroundView.navigationState.navigateToHillsideCafeOptions()
                } else if annotation.title == "Global Cafe" {
                    mapBackgroundView.navigationState.navigateToGlobalCafeOptions()
                } else if annotation.title == "Iacocca Café" {
                    mapBackgroundView.navigationState.navigateToIacoccaCafeOptions()
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
        print("Navigating to RathboneDetailsView")
    }
    
    func navigateToHawksNestOptions() {
        print("Navigating to HawksNestOptionsView")
    }
    
    func navigateToTheGrindOptions() {
        print("Navigating to TheGrindOptionsView")
    }
    
    func navigateToCommonGroundsOptions() {
        print("Navigating to CommonGroundsOptionsView")
    }
    
    func navigateToHideawayCafeOptions() {
        print("Navigating to HideawayCafeOptionsView")
    }
    
    func navigateToLucysCafeOptions() {
        print("Navigating to LucysCafeOptionsView")
    }
    
    func navigateToHillsideCafeOptions() {
        print("Navigating to HillsideCafeOptionsView")
    }
    
    func navigateToGlobalCafeOptions() {
        print("Navigating to GlobalCafeOptionsView")
    }
    
    func navigateToIacoccaCafeOptions() {
        print("Navigating to IacoccaCafeOptionsView")
    }
}

struct HomeView: View {
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        NavigationView {
            ZStack {
                if !navigationState.isButtonClicked {
                    MapBackgroundView()
                        .edgesIgnoringSafeArea(.all)
                }
                
                if navigationState.isButtonClicked {
                    if navigationState.selectedLocation == "Rathbone Dining Hall" {
                        RathboneDetailsView()
                    } else if navigationState.selectedLocation == "Hawk's Nest" {
                        HawksNestDetailsView()
                    } else if navigationState.selectedLocation == "The Grind @ FML" {
                        TheGrindDetailsView()
                    } else if navigationState.selectedLocation == "Common Grounds" {
                        CommonGroundsDetailsView()
                    } else if navigationState.selectedLocation == "The Hideaway Cafe" {
                        HideawayCafeDetailsView()
                    } else if navigationState.selectedLocation == "Lucy's Café" {
                        LucysCaféDetailsView()
                    } else if navigationState.selectedLocation == "Hillside Cafe" {
                        HillsideCafeDetailsView()
                    } else if navigationState.selectedLocation == "Global Cafe" {
                        GlobalCaféDetailsView()
                    } else if navigationState.selectedLocation == "Iacocca Café" {
                        IacoccaCaféDetailsView()
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationState())
    }
}
