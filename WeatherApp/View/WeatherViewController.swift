//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController {
    
    private let weatherView = UIHostingController(rootView: SearchWeatherView(viewModel: WeatherViewModel()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        // Add the SwiftUI weather view as a child view controller
        addChild(weatherView)
        view.addSubview(weatherView.view)
        weatherView.didMove(toParent: self)
        
        // Set up constraints for the weather view to fill the entire safe area
        weatherView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weatherView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weatherView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
