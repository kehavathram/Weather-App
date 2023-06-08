//
//  ImageTableViewCell.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }
    
    private func setupImageView() {
        contentView.addSubview(weatherImageView)
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weatherImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            weatherImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            weatherImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}
