//
//  WeatherInfo.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit

/// Model class that contains relevant weather information data.
class WeatherInfo: CustomDebugStringConvertible {

    /// Name of the location.
    let locationName: String

    /// Current temperature for specified location.
    let currentTemperature: Measurement<UnitTemperature>

    /// Minimum temperature for specified location.
    let minTemperature: Measurement<UnitTemperature>

    /// Maximum temperature for specified location.
    let maxTemperature: Measurement<UnitTemperature>

    // MARK: - CustomDebugStringConvertible implementation

    var debugDescription: String {
        return "\(locationName): \(currentTemperature) (\(minTemperature) - \(maxTemperature))"
    }

    // MARK: - Initialization

    init(locationName: String, currentTemperature: Double, minTemperature: Double, maxTemperature: Double) {
        self.locationName = locationName

        // TODO: The current API returns units in kelvin by default, which we use as the baseline
        // This should obviously be set up in the weather provider and passed as a paremeter
        self.currentTemperature = Measurement(value: currentTemperature, unit: .kelvin)
        self.minTemperature = Measurement(value: minTemperature, unit: .kelvin)
        self.maxTemperature = Measurement(value: maxTemperature, unit: .kelvin)
    }

}
