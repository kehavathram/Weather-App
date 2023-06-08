//
//  WeatherSearchView.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import SwiftUI

struct SearchWeatherView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    @State private var city: String = ""
    @State private var stateCode: String = ""
    @State private var countryCode: String = ""
    
    var body: some View {
        VStack {
            Group {
                Text("Weather App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                TextField("Enter city", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("State code (US only)", text: $stateCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Country code", text: $countryCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Fetch Weather") {
                    viewModel.fetchWeather(city: city, stateCode: stateCode, countryCode: countryCode)
                }
                .buttonStyle(.bordered)
            }
            
            // Group to structure display of weather data or error message
            Group {
                if (viewModel.weatherData != nil) {
                    WeatherDetailsUIRepresentable(weatherData: $viewModel.weatherData)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.startFetchingData() // On view appearance, begin fetching data
        }
    }
}
