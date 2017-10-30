//
//  MapViewController.swift
//  iLAB_iOS_Junior_Developer_Assignment
//
//  Created by Mark Peneder on 26/10/2017.
//  Copyright © 2017 Mark Peneder. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations : [MKPointAnnotation] = [MKPointAnnotation]()
    var myRoute : MKRoute = MKRoute()
    var startOffice : Offices?
    var destinationOffice : Offices?
    
    let vaduzColor = UIColor(red:0.53, green:0.00, blue:0.27, alpha:1.0)
    let zurichColor = UIColor(red:0.22, green:0.00, blue:0.19, alpha:1.0)
    let milanColor = UIColor(red:1.00, green:0.93, blue:0.53, alpha:1.0)
    
    //Zurich, Milan, Vaduz
    var officeCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 47.3662755, longitude: 8.4998601), CLLocationCoordinate2D(latitude: 45.5012347, longitude: 9.1294536),CLLocationCoordinate2D(latitude: 47.1267392, longitude: 9.5216284)]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Map"
        mapView.delegate = self
        
        let officeTitles = ["Gärnischstrasse 18, 8002 Zurich, Switzerland", "Via Montefeltro 6, 20156 Milan, Italy", "Pflugstrasse 10/12, 9490 Vaduz, Liechtenstein"]
        
        for index in 0...officeCoordinates.count-1 {
            let annotation = MKPointAnnotation() 
            annotation.coordinate = officeCoordinates[index]
            annotation.title = officeTitles[index]
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
        fitAllAnnotations()
    }
    
    func renderRouteForChosenOffices () {
        let directionsRequest = MKDirectionsRequest()
        
        let source = MKPlacemark(coordinate: officeCoordinates[startOffice?.rawValue ?? Offices.Milan.rawValue])
        let destination = MKPlacemark(coordinate: officeCoordinates[destinationOffice?.rawValue ?? Offices.Zurich.rawValue])
        
        directionsRequest.source = MKMapItem(placemark: source)
        directionsRequest.destination = MKMapItem(placemark: destination)
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            
        }
    }
    
    /**
     Adapts the zoom level that all map pins are visible.
     */
    func fitAllAnnotations() {
        var zoomRect = MKMapRectNull;
        for annotation in annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(50, 50, 50, 50), animated: true)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = getColorForChosenOffice(startOffice ?? Offices.Milan)
        renderer.lineWidth = 2
        return renderer
    }
    
    func getColorForChosenOffice(_ startOffice: Offices) -> UIColor {
        switch startOffice {
        case .Milan:
            return self.milanColor
        case .Zurich:
            return self.zurichColor
        case .Vaduz:
            return self.vaduzColor
        }
    }

    func getColorForOfficeTitle (_ officeTitle: String) -> UIColor? {
        if officeTitle.range(of: "Zurich") != nil {
            return self.zurichColor
        } else if officeTitle.range(of: "Vaduz") != nil{
            return self.vaduzColor
        } else {
            return self.milanColor
        }

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        if let color = getColorForOfficeTitle (annotation.title!!) {
            annotationView.pinTintColor = color
        }
        annotationView.canShowCallout = true
        
        return annotationView
    }
}
