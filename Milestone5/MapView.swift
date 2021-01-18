//
//  MapView.swift
//  NewFriends
//
//  Created by Anmol  Jandaur on 1/7/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    @State var centerCoordinate: CLLocationCoordinate2D
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        annotation.title = "Location"
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: false)
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
        }
        
    }
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: CLLocationCoordinate2D(latitude: 50.0, longitude: 75.0))
    }
}
