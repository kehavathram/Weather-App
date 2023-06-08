//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import UIKit
import Combine

enum WeatherSection: Int, CaseIterable {
    case currentWeather = 0
    case image
    case temperature
    case additionalDetails
    
    var title: String {
        switch self {
        case .currentWeather:
            return "Current Weather"
        case .image:
            return "Image"
        case .temperature:
            return "Temp"
        case .additionalDetails:
            return "Additional Details"
        }
    }
}

class WeatherDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var weatherData: WeatherData? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tableView: UITableView!
    private let placeholderImage = UIImage(named: "placeholder")
    private var cancellables = Set<AnyCancellable>()
    private var imageLoader = ImageLoader()
    
    init(weatherData: WeatherData?) {
        self.weatherData = weatherData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "imageCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // Set up auto layout constraints for the tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            if self.traitCollection.verticalSizeClass == .compact {
                // Adjustments for landscape mode
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = 80
            } else {
                // Adjustments for portrait mode
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = 120
            }
        }, completion: nil)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherSection = WeatherSection(rawValue: section) else { return 0 }
        
        switch weatherSection {
        case .currentWeather:
            return 2 // City and Temperature
        case .image:
            return weatherData?.weather.first?.icon != nil ? 1 : 0 // Only display if there is an image
        case .temperature, .additionalDetails:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return WeatherSection(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherSection(rawValue: indexPath.section) else {
            fatalError("Invalid section")
        }
        
        switch section {
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageTableViewCell else {
                fatalError("Unable to dequeue ImageTableViewCell")
            }
            if let icon = weatherData?.weather.first?.icon, let iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon).png") {
                loadImage(from: iconURL, for: cell)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
            configureCell(cell, for: section, row: indexPath.row)
            return cell
        }
    }
    
    private func configureCell(_ cell: UITableViewCell, for section: WeatherSection, row: Int) {
        guard let weatherData = weatherData else { return }
        
        switch section {
        case .currentWeather:
            switch row {
            case 0:
                cell.textLabel?.text = "City: \(weatherData.name)"
            case 1:
                cell.textLabel?.text = "\(weatherData.main.temp)°"
            default:
                break
            }
            
        case .temperature:
            switch row {
            case 0:
                cell.textLabel?.text = "Min temperature: \(weatherData.main.temp_min)°"
            case 1:
                cell.textLabel?.text = "Max temperature: \(weatherData.main.temp_max)°"
            case 2:
                cell.textLabel?.text = "Humidity: \(weatherData.main.humidity)"
            case 3:
                cell.textLabel?.text = "Wind Speed: \(weatherData.wind?.speed ?? 0.0)"
            default:
                break
            }
            
        case .additionalDetails:
            switch row {
            case 0:
                cell.textLabel?.text = "Wind Direction: \(weatherData.wind?.deg ?? 0)°"
            case 1:
                cell.textLabel?.text = "Visibility: \(weatherData.visibility ?? 0)"
            case 2:
                cell.textLabel?.text = "Sunrise: \(formatTimestamp(weatherData.sys?.sunrise ?? 0))"
            case 3:
                cell.textLabel?.text = "Sunset: \(formatTimestamp(weatherData.sys?.sunset ?? 0))"
            default:
                break
            }
            
        default:
            break
        }
    }
    
    // MARK: - Private methods
    
    private func formatTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func loadImage(from url: URL, for cell: ImageTableViewCell) {
        imageLoader.loadImageFor(url: url) { [weak self] image in
            cell.weatherImageView.image = image ?? self?.placeholderImage
            cell.setNeedsLayout()
        }
    }
}
