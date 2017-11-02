//
//  WeatherProvider.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit

/// Protocol that represents a specific weather provider.
protocol WeatherProvider {

    /// Network utility class for the weather provider.
    var networkUtility: WeatherProviderNetworkUtility { get }

    /// Serializer for the weather provider.
    var serializer: WeatherProviderSerializer { get }

}
