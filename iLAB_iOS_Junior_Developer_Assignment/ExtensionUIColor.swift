//
//  ExtensionUIColor.swift
//  iLAB_iOS_Junior_Developer_Assignment
//
//  Created by Laureen Schausberger on 30/10/2017.
//  Copyright © 2017 Mark Peneder. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // MARK: - Standard-Coloring-Colored
    class var vaduzColor: UIColor {
        return UIColor(red:0.53, green:0.00, blue:0.27, alpha:1.0)
    }
    
    class var zurichColor: UIColor {
        return UIColor(red:0.22, green:0.00, blue:0.19, alpha:1.0)
    }
    
    class var milanColor: UIColor {
        return UIColor(red:0.14, green:0.71, blue:0.83, alpha:1.0)

    }
    
    class func getColorForChosenOffice(_ startOffice: Offices) -> UIColor {
        switch startOffice {
        case .Milan:
            return self.milanColor
        case .Zurich:
            return self.zurichColor
        case .Vaduz:
            return self.vaduzColor
        }
    }
    
    class func getColorForOfficeTitle (_ officeTitle: String) -> UIColor? {
        if officeTitle.range(of: "Zurich") != nil {
            return self.zurichColor
        } else if officeTitle.range(of: "Vaduz") != nil{
            return self.vaduzColor
        } else {
            return self.milanColor
        }
        
    }
}
