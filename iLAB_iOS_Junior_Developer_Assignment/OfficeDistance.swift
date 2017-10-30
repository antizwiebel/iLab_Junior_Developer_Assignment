//
//  OfficeDistance.swift
//  iLAB_iOS_Junior_Developer_Assignment
//
//  Created by Laureen Schausberger on 26/10/2017.
//  Copyright © 2017 Mark Peneder. All rights reserved.
//

import Foundation
import MapKit

class OfficeDistance{
    var route : MKRoute
    var startOffice : Offices
    var destinationOffice : Offices
    
    init(startOffice start: Offices, destinationOffice destination: Offices, route: MKRoute) {
        startOffice = start
        destinationOffice = destination
        self.route = route
    }
    
}
