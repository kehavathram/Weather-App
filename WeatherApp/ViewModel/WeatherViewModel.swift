//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import Combine
import CoreLocation
import Foundation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private let weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    private let lastFetchedWeatherKey = "LastFetchedWeatherData"
    
    @Published var weatherData: WeatherData?
    @Published var errorMessage: String?
    
    // MARK: - Initialization
    
    override init() {
        self.weatherService = WeatherService()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Public Methods
    
    func fetchWeather(city: String, stateCode: String? = nil, countryCode: String? = nil) {
        weatherService.fetchWeather(city: city, stateCode: stateCode, countryCode: countryCode)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.weatherData = nil
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] weatherData in
                guard let self = self else { return }
                self.weatherData = weatherData
                self.errorMessage = nil
                self.saveLastFetchedWeatherData()
            }
            .store(in: &cancellables)
    }
    
    func startFetchingData() {
        checkLocationAuthorizationStatus()
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        weatherService.fetchCityName(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.loadLastFetchedWeatherData()
                }
            }, receiveValue: { [weak self] cityName in
                guard let self = self else { return }
                self.fetchWeather(city: cityName)
            })
            .store(in: &cancellables)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            loadLastFetchedWeatherData()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
        loadLastFetchedWeatherData()
    }
    
    // MARK: - Private Methods
    
    private func checkLocationAuthorizationStatus() {
        let authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            loadLastFetchedWeatherData()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    private func saveLastFetchedWeatherData() {
        guard let encodedData = try? JSONEncoder().encode(weatherData) else {
            return
        }
        
        UserDefaults.standard.set(encodedData, forKey: lastFetchedWeatherKey)
    }
    
    private func loadLastFetchedWeatherData() {
        guard let encodedData = UserDefaults.standard.data(forKey: lastFetchedWeatherKey) else {
            DispatchQueue.main.async {
                self.errorMessage = "Please enter location"
            }
            
            return
        }
        
        DispatchQueue.main.async {
            self.weatherData = try? JSONDecoder().decode(WeatherData.self, from: encodedData)
        }
    }
}
