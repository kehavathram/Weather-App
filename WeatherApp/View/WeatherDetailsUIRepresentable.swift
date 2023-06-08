//
//  WeatherDetailsUIRepresentable.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import SwiftUI

struct WeatherDetailsUIRepresentable: UIViewControllerRepresentable {
    @Binding var weatherData: WeatherData?

    func makeUIViewController(context: Context) -> WeatherDetailsViewController {
        return WeatherDetailsViewController(weatherData: weatherData)
    }

    func updateUIViewController(_ uiViewController: WeatherDetailsViewController, context: Context) {
        // Here we update the weather data of the WeatherDetailsViewController
        uiViewController.weatherData = weatherData
    }
}

