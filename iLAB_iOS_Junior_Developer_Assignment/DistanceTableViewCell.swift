//
//  DistanceTableViewCell.swift
//  iLAB_iOS_Junior_Developer_Assignment
//
//  Created by Laureen Schausberger on 26/10/2017.
//  Copyright © 2017 Mark Peneder. All rights reserved.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {

    @IBOutlet weak var startOffice: UILabel!
    @IBOutlet weak var destinationOffice: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var distanceKm: UILabel!
    @IBOutlet weak var distanceHours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
