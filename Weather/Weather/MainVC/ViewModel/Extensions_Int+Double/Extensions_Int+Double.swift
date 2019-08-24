//
//  Extensions_Int+Double.swift
//  Weather
//
//  Created by Gio Lomsa on 6/30/19.
//  Copyright © 2019 Giorgi Lomsadze. All rights reserved.
//

import Foundation

extension Double{
    var temperatureToString: String{
        return String(Int(self)) + "º"
    }
    
    var weatherSpeedToString: String{
        return "Speed: " + String(self) + "mps"
    }
}

extension Int{
    var degreeToString: String{
        return "Degree: " + String(self) + "º"
    }
    
    public var isSuccessHTTPCode: Bool {
        return 200 <= self && self < 300
    }
}

