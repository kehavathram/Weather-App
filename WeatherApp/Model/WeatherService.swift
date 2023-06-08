//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import Foundation
import Combine


enum WeatherError: Error {
    case invalidURL
    case invalidLocation
    case invalidResponse
}

protocol WeatherServiceProtocol {
    func fetchWeather(city: String, stateCode: String?, countryCode: String?) -> AnyPublisher<WeatherData, Error>
    func fetchCityName(latitude: Double, longitude: Double) -> AnyPublisher<String, Error>
    func fetchImageForURL(url: URL) -> AnyPublisher<Data, URLError>
}

class WeatherService: WeatherServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder

    // Initialization of URLSession and JSONDecoder.
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchWeather(city: String, stateCode: String?, countryCode: String?) -> AnyPublisher<WeatherData, Error> {
        
        // Constructing the URL with query parameters
        guard let url = URLComponents(string: "\(APIConstants.baseURL)\(APIConstants.weatherEndpoint)") else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }

        var components = url
        components.queryItems = [
            URLQueryItem(name: "q", value: "\(city)\(stateCode.map { ",\($0)" } ?? "")\(countryCode.map { ",\($0)" } ?? "")"),
            URLQueryItem(name: "appid", value: APIConstants.apiKey)
        ]

        guard let finalURL = components.url else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }
        
        // Fetching weather data using URLSession's dataTaskPublisher method
        return session.dataTaskPublisher(for: finalURL)
            .mapError { _ in WeatherError.invalidResponse }
            .map { $0.data }
            .decode(type: WeatherData.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func fetchCityName(latitude: Double, longitude: Double) -> AnyPublisher<String, Error> {
        
        // Constructing the URL with query parameters
        guard let url = URLComponents(string: "\(APIConstants.baseURL)\(APIConstants.geocodingEndpoint)") else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }

        var components = url
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: APIConstants.apiKey)
        ]

        guard let finalURL = components.url else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }
        
        // Fetching city name using URLSession's dataTaskPublisher method
        return session.dataTaskPublisher(for: finalURL)
            .mapError { _ in WeatherError.invalidResponse }
            .map { $0.data }
            .decode(type: Location.self, decoder: decoder)
            .map { $0.name }
            .eraseToAnyPublisher()
    }
    
    func fetchImageForURL(url: URL) -> AnyPublisher<Data, URLError> {
        // Fetching image data using URLSession's dataTaskPublisher method
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

