//
//  CLLocationCoordinate2DExtension.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit
import MapKit

typealias CLLocationDictionary = [String: CLLocationDegrees]

/// Utility extension for CLLocationCoordinate2D that allows it to be packed/unpacked easier.
/// @link: https://stackoverflow.com/a/44351848/2734193
extension CLLocationCoordinate2D {

    private static let Lat = "lat"
    private static let Lon = "lon"

    var asDictionary: CLLocationDictionary {
        return [CLLocationCoordinate2D.Lat: self.latitude,
                CLLocationCoordinate2D.Lon: self.longitude]
    }

    init(dict: CLLocationDictionary) {
        self.init(latitude: dict[CLLocationCoordinate2D.Lat]!,
                  longitude: dict[CLLocationCoordinate2D.Lon]!)
    }

}
