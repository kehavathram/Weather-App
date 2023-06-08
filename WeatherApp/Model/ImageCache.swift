//
//  ImageCache.swift
//  WeatherApp
//
//  Created by Thukaram Kethavath on 05/07/23.
//

import SwiftUI

class ImageCache {
    
    private var cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.totalCostLimit = 100 * 1024 * 1024 // Set a memory limit for the cache, e.g., 100 MB
        return cache
    }()

    func getImage(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL, cost: image.diskSize)
    }
}

extension UIImage {
    var diskSize: Int {
        guard let imageData = self.pngData() else { return 0 }
        return imageData.count
    }
}
