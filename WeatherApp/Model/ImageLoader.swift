//
//  ImageLoader.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import Combine
import Foundation
import UIKit

class ImageLoader {
    
    private var cancellables = Set<AnyCancellable>()
    private static let cache = ImageCache()
    private static let queue = DispatchQueue(label: "ImageLoaderQueue")
    private var completion: ((UIImage?) -> Void)?
    
    func loadImageFor(url: URL, completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
        if let cachedImage = ImageLoader.cache.getImage(for: url) {
            DispatchQueue.main.async {
                self.completion?(cachedImage)
            }
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap { UIImage(data: $0) }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error loading image: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] image in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.completion?(image)
                }
                ImageLoader.cache.setImage(image, for: url)
            }
            .store(in: &cancellables)
    }

    func cancel() {
        cancellables.removeAll()
    }
}
