//
//  OfficeDistanceTableViewController.swift
//  iLAB_iOS_Junior_Developer_Assignment
//
//  Created by Laureen Schausberger on 26/10/2017.
//  Copyright © 2017 Mark Peneder. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class OfficeDistanceTableViewController: UITableViewController {

    let vaduzColor = UIColor(red:0.53, green:0.00, blue:0.27, alpha:1.0)
    let zurichColor = UIColor(red:0.22, green:0.00, blue:0.19, alpha:1.0)
    let milanColor = UIColor(red:1.00, green:0.93, blue:0.53, alpha:1.0)
    
    //ORDER: Milan, Vaduz,Zurich
    var officeCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 45.5012347, longitude: 9.1294536), CLLocationCoordinate2D(latitude: 47.1267392, longitude: 9.5216284),CLLocationCoordinate2D(latitude: 47.3662755, longitude: 8.4998601)]
    
    var officeDistances : [OfficeDistance] = [OfficeDistance]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Distances between offices"
        calculateRoutesBetweenOffices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  6
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "distanceCell", for: indexPath) as! DistanceTableViewCell

        //make sure routes have been calculated
        if indexPath.row < officeDistances.count {
            let officeDistance = officeDistances[indexPath.row]
            cell.distanceKm.text = String(format: "%.2f", officeDistance.route.distance / 1000) + " km"
            
            
            //calculate time in hours
            let distanceInHours = String(Int(officeDistance.route.expectedTravelTime / 3600))
            //calculate remaining time in minutes
            let distanceInMinutes = String(format: "%02d",Int(officeDistance.route.expectedTravelTime.truncatingRemainder(dividingBy: 3600) / 60))
            cell.distanceHours.text = distanceInHours + ":" + distanceInMinutes + " h"
            
            cell.startOffice.text = String(describing: officeDistance.startOffice)
            cell.destinationOffice.text = String(describing: officeDistance.destinationOffice)
            cell.carImage.backgroundColor = UIColor.getColorForChosenOffice(officeDistance.startOffice)
            cell.lineView.backgroundColor = UIColor.getColorForChosenOffice(officeDistance.startOffice)

        }
        return cell
    }
    
    func calculateRoutesBetweenOffices () {
        let directionsRequest = MKDirectionsRequest()
        
        for index1 in 0...officeCoordinates.count-1 {
            for index2 in 0...officeCoordinates.count-1 {
                if index1 != index2 {
                    let source = MKPlacemark(coordinate: officeCoordinates[index1])
                    let destination = MKPlacemark(coordinate: officeCoordinates[index2])
                    
                    directionsRequest.source = MKMapItem(placemark: source)
                    directionsRequest.destination = MKMapItem(placemark: destination)
                    getroute(directionsRequest, Offices(rawValue: index1) ?? Offices.Milan, Offices(rawValue: index2) ?? Offices.Zurich)
                }
                
            }
        }
        
    }
    
    func getroute (_ directionsRequest: MKDirectionsRequest,_ startOffice: Offices, _ destinationOffice: Offices) {
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            self.officeDistances.append(OfficeDistance(startOffice: startOffice, destinationOffice: destinationOffice,  route: response.routes[0]))
            self.tableView.reloadData()
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showRoute":
                let destinationViewController = segue.destination as! MapViewController
                
                let selectedOfficeDistance = self.officeDistances[(self.tableView.indexPathForSelectedRow?.row) ?? 0]
                destinationViewController.startOffice = selectedOfficeDistance.startOffice
                destinationViewController.destinationOffice = selectedOfficeDistance.destinationOffice
                destinationViewController.renderRouteForChosenOffices()
                destinationViewController.title = "Route from " + String(describing: selectedOfficeDistance.startOffice) + " to " + String(describing: selectedOfficeDistance.destinationOffice)
                break
            default: break
            }
        }
    }
    
}
