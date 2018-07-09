//
//  MCImageCache.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 06/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

final class MCImageCache {

    private let imageCache = NSCache<NSString, AnyObject>()

    func cachedImage(forKey key: String?) -> UIImage? {
        guard let key = key else { return nil }
        let image = imageCache.object(forKey: key as NSString)
        return image as? UIImage
    }

    func set(image: UIImage?, forKey key: String?) {
        guard let image = image, let key = key else { return }
        imageCache.setObject(image, forKey: key as NSString)
    }
}
