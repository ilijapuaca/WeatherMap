//
//  WeatherProviderSerializer.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit

/// Protocol that takes care of weather info serialization for a specific weather provider.
protocol WeatherProviderSerializer {

    func deserialize(_: Any) -> WeatherInfo?

}
