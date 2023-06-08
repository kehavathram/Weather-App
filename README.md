# Basic Weather Application for iOS
This project aims to create an iOS app-based application that serves as a basic weather app. The main feature of the app includes searching weather by entering a US city. The app will utilize the OpenWeatherMap API to fetch and display relevant weather information.

# Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

# Prerequisites
Make sure you have Xcode installed, a stable internet connection, and a MacOS device with a proper development environment set up.

# Installing
Clone this repository: git clone https://github.com/kehavathram/Weather-App.git
Navigate into the directory: cd weather-app-ios
Open the project in Xcode: open WeatherApp.xcodeproj
Run the project in your preferred iOS simulator or physical device.

# Features
1. Search Screen: Allows customers to input any US city and fetch the weather data of the respective city.
2. Utilizes OpenWeatherMap API to get and display weather data. The app is designed to showcase useful information that a user might want to see, including a weather icon.
3. Image caching: If the app has fetched and displayed a certain weather icon previously, it will cache it for future use.
4. Auto-load Last City: The last searched city's weather is automatically displayed upon app launch.
5. Location Access: The app will ask the user for location access. If the user grants permission, it will retrieve and display the weather of the user's current location by default.

# Coding Standards
1. Proper Function: The app meets all the requirements and functions properly.
2. Clean and Commented Code: The codebase is easy to follow and understand. Comments are used effectively to provide context and explain any hacks or workarounds.
3. Separation of Concerns: The codebase follows the best-practice coding patterns, ensuring each part of the code has a distinct and clear role.
4. Defensive Coding: The code can gracefully handle unexpected edge cases.

# Built With
Swift
OpenWeatherMap API


# Authors
Thukaram Kethavath - Initial work - kethavathram
