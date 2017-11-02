//
//  WeatherInfo.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit
import MapKit

/// Model class that contains relevant weather information data.
class WeatherInfo: NSObject, NSCoding {

    // MARK: - Properties

    /// Location that this WeatherInfo instance represents.
    let location: CLLocationCoordinate2D

    /// Name of the location.
    let locationName: String

    /// Current temperature for specified location.
    let currentTemperature: Measurement<UnitTemperature>

    /// Minimum temperature for specified location.
    let minTemperature: Measurement<UnitTemperature>

    /// Maximum temperature for specified location.
    let maxTemperature: Measurement<UnitTemperature>

    // MARK: - NSCoding dictionary keys

    private static let locationKey = "location"
    private static let locationNameKey = "locationName"
    private static let currentTemperatureKey = "currentTemperature"
    private static let minTemperatureKey = "minimumTemperature"
    private static let maxTemperatureKey = "maximumTemperature"

    // MARK: - CustomDebugStringConvertible implementation

    override var debugDescription: String {
        return "\(locationName): \(currentTemperature) (\(minTemperature) - \(maxTemperature))"
    }

    // MARK: - Initialization

    init(location: CLLocationCoordinate2D, locationName: String, currentTemperature: Double,
         minTemperature: Double, maxTemperature: Double) {
        self.location = location
        self.locationName = locationName

        // TODO: The current API returns units in kelvin by default, which we use as the baseline
        // This should obviously be set up in the weather provider and passed as a paremeter
        self.currentTemperature = Measurement(value: currentTemperature, unit: .kelvin)
        self.minTemperature = Measurement(value: minTemperature, unit: .kelvin)
        self.maxTemperature = Measurement(value: maxTemperature, unit: .kelvin)
    }

    // MARK: - NSCoding implementation

    required convenience init?(coder aDecoder: NSCoder) {
        guard let locationDict = aDecoder.decodeObject(forKey: WeatherInfo.locationKey) as? CLLocationDictionary,
              let locationName = aDecoder.decodeObject(forKey: WeatherInfo.locationNameKey) as? String
            else { return nil }

        let currentTemperature = aDecoder.decodeDouble(forKey: WeatherInfo.currentTemperatureKey)
        let minTemperature = aDecoder.decodeDouble(forKey: WeatherInfo.minTemperatureKey)
        let maxTemperature = aDecoder.decodeDouble(forKey: WeatherInfo.maxTemperatureKey)

        self.init(location: CLLocationCoordinate2D(dict: locationDict), locationName: locationName,
                  currentTemperature: currentTemperature, minTemperature: minTemperature, maxTemperature: maxTemperature)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(location.asDictionary, forKey: WeatherInfo.locationKey)
        aCoder.encode(locationName, forKey: WeatherInfo.locationNameKey)
        aCoder.encode(currentTemperature.value, forKey: WeatherInfo.currentTemperatureKey)
        aCoder.encode(minTemperature.value, forKey: WeatherInfo.minTemperatureKey)
        aCoder.encode(maxTemperature.value, forKey: WeatherInfo.maxTemperatureKey)
    }

}
