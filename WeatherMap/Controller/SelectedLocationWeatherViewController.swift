//
//  SelectedLocationWeatherViewController.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit
import MapKit

/// View controller that shows relevant weather information for previously selected location.
class SelectedLocationWeatherViewController: UIViewController {

    // MARK: - Properties

    /// Location to show the weather for.
    var location: CLLocation?

    /// Network manager that'll be used for networking operations.
    private let networkManager = WeatherNetworkManager()

    // MARK: - Outlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherInfoView: WeatherInfoView!

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        if let location = location {
            updateWeatherData(location: location)

            mapView.setCenter(location.coordinate, animated: false)

            // Add a pin to the map
            let locationPin = MKPointAnnotation()
            locationPin.coordinate = location.coordinate
            mapView.addAnnotation(locationPin)

            // TODO: Zoom on to locationPin coordinates
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Utility methods

    private func updateWeatherData(location: CLLocation) {
        // TODO: Show some kind of loading indicator
        networkManager.fetchWeatherInfo(coordinate: location.coordinate) { (weatherInfo, error) in
            if error != nil {
                // This is obviously a very poor way of handling this. Should be shown in a nicer way and the case when there is no
                // internet connectivity should be handled separately
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("GENERIC_ERROR_TITLE", comment: ""), message: NSLocalizedString("GENERIC_FETCH_ERROR_DETAILS", comment: ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

                return
            }

            DispatchQueue.main.async {
                self.weatherInfoView.show(weatherInfo: weatherInfo!)
            }
        }
    }

}
