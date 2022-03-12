//
//  ContentView.swift
//  swiftUIMap
//
//  Created by Eymen Varilci on 27.02.2022.
//

import SwiftUI
import MapKit
import CoreLocation
struct ContentView: View {
   
    @StateObject private var viewModel = contentViewModel()
    
    var body: some View {
        
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear{
                viewModel.checkIfLocationsAnabled()
            }
        
        
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
final class contentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.20337, longitude: 16.36982), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    
    var locationManager: CLLocationManager?
   
    func checkIfLocationsAnabled(){
       
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
        } else {
            
            print("error")
        }
        
    }
  private  func checkLocationAuthorization() {
        
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus{
            
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .restricted:
            print("your location is restricted")
        case .denied:
            print("you have denied location permisson")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        @unknown default:
            break
        }

        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    
}
