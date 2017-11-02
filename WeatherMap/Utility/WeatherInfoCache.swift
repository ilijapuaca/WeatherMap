//
//  WeatherInfoCache.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit
import MapKit

/// A very rudamentary implementation of cache that uses UserDefaults.
/// It requires the location to be at the exact spot for it to retrieve related WeatherInfo, making it not-that-usable.
/// TODO: An implementation based on NSCache would be more appropriate here.
/// TODO: The cache should work on area based principle, where we would store the location as the center and add an
/// arbitrary range, that way we could easily determine proximity to another location that we are trying to retrieve the data for.
class WeatherInfoCache {

    /// Default cache instance.
    static let `default` = WeatherInfoCache()

    /// UserDefaults instance to use for storage.
    private let userDefaults: UserDefaults

    // MARK: - Initialization

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Caching operations

    /// Adds weatherInfo to the cache so that it can be retrieved by its location at a later point.
    ///
    /// - Parameter weatherInfo: WeatherInfo object to cache
    func add(_ weatherInfo: WeatherInfo) {
        let data = NSKeyedArchiver.archivedData(withRootObject: weatherInfo)
        userDefaults.set(data, forKey: hash(for: weatherInfo.location))
        userDefaults.synchronize()

        // TODO: Implement some kind of a cleanup mechanism for these.
        // The data should expire if it is older than a certain period of time
    }

    func retrieve(location: CLLocationCoordinate2D) -> WeatherInfo? {
        if let data = userDefaults.object(forKey: hash(for: location)) as? Data,
           let weatherInfo = NSKeyedUnarchiver.unarchiveObject(with: data) {
            return weatherInfo as? WeatherInfo
        }

        return nil
    }

    // MARK: - Utility methods

    private func hash(for location: CLLocationCoordinate2D) -> String {
        return "\(location.latitude), \(location.longitude)"
    }

}
