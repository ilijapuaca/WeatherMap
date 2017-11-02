//
//  CurrentLocationWeatherViewController.swift
//  WeatherMap
//
//  Created by Ilija Puaca on 2/11/17.
//  Copyright © 2017 Authentic Company. All rights reserved.
//

import UIKit
import MapKit

/// View controller in charge of showing weather information for the current location.
class CurrentLocationWeatherViewController: UIViewController {

    // MARK: - Properties

    /// Network manager that'll be used for network operations.
    private let networkManager = WeatherNetworkManager()

    /// Weather info cache to be used for caching/retrieving weather info data.
    private let weatherInfoCache = WeatherInfoCache.default

    /// Location manager instance used to fetch the location.
    private var locationManager: CLLocationManager!

    /// Location for which the weather is being shown for currently.
    private var currentWeatherLocation: CLLocation?

    /// Desired accuracy in meters. Less accurate locations will be discarded.
    /// NOTE: It is super rare that we get a location accurate within <= 10 meters indoors.
    /// Setting this to anything less than 16 would rarely provide any usable results.
    /// NOTE: For devices without GPS chip, set the accuracy to a larger value as we will never get really precise location.
    private var desiredAccuracy = CLLocationManager.deferredLocationUpdatesAvailable() ? 64.0 : 100.0

    /// Distance in meters that needs to be crossed in order for weather data to be updated again.
    private var locationUpdateThreshold = 1000.0

    /// Boolean indicating whether initial user location has been set.
    private var initialLocationSet = false

    // MARK: - Outlets

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onLocationSelected(_:)))
            doubleTapRecognizer.delegate = self
            doubleTapRecognizer.numberOfTapsRequired = 2
            doubleTapRecognizer.numberOfTouchesRequired = 1
            mapView.addGestureRecognizer(doubleTapRecognizer)
        }
    }
    @IBOutlet weak var weatherInfoView: WeatherInfoView!

    // MARK: - Segues

    private let showWeatherSegue = "ShowWeather"

    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar for this screen
        navigationController?.navigationBar.isHidden = true

        // Start location updates service
        startLocationUpdates()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop location update service
        stopLocationUpdates()
    }

    // MARK: - Utility methods

    private func startLocationUpdates() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self

        // Request proper authorization for location updates
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        locationManager = nil
    }

    private func updateWeatherData(location: CLLocation) {
        if let cachedWeatherInfo = weatherInfoCache.retrieve(location: location.coordinate) {
            DispatchQueue.main.async {
                self.weatherInfoView.show(weatherInfo: cachedWeatherInfo)
            }

            return
        }

        // TODO: Show some kind of loading indicator
        networkManager.fetchWeatherInfo(coordinate: location.coordinate) { [weak self] (weatherInfo, error) in
            guard let `self` = self else {
                return
            }

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

            if let weatherInfo = weatherInfo {
                DispatchQueue.main.async {
                    self.weatherInfoCache.add(weatherInfo)
                    self.weatherInfoView.show(weatherInfo: weatherInfo)
                }
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWeatherSegue {
            if let selectedLocationWeatherVC = segue.destination as? SelectedLocationWeatherViewController,
               let location = sender as? CLLocation {
                selectedLocationWeatherVC.location = location
            }
        }
    }

    // MARK: - User actions

    @objc
    private func onLocationSelected(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .recognized else {
            return
        }

        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)

        let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        performSegue(withIdentifier: showWeatherSegue, sender: location)
    }

}

extension CurrentLocationWeatherViewController: CLLocationManagerDelegate {

    // MARK: - CLLocationManagerDelegate implementation

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Apparently this gets called every time CLLocationManager is initialized, so this is the only place we need to start updates in

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // There's always at least one location available
        let location = locations.last!

        let locationDistance = currentWeatherLocation?.distance(from: location) ?? Double.greatestFiniteMagnitude
        guard locationDistance > locationUpdateThreshold else {
            return
        }

        // Check if location is precise enough
        let isPreciseEnough = location.horizontalAccuracy <= desiredAccuracy

        // Check if location is recent enough as CoreLocation framework caches location data and we can get some super old result
        let isRecentEnough = location.timestamp.timeIntervalSinceNow > -10.0

        if isPreciseEnough && isRecentEnough {
            currentWeatherLocation = location

            updateWeatherData(location: location)
        }
    }

}

extension CurrentLocationWeatherViewController: MKMapViewDelegate {

    // MARK: - MKMapViewDelegate implementation

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard !initialLocationSet else {
            return
        }

        // Center the initial user location
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(region, animated: true)

        initialLocationSet = true
    }

}

extension CurrentLocationWeatherViewController: UIGestureRecognizerDelegate {

    // MARK: - UIGestureRecognizerDelegate implementation

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Our gesture recognizer must take priority over default MKMapView one
        return true
    }

}
