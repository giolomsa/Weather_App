//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Gio Lomsa on 6/28/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    // IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tamperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

