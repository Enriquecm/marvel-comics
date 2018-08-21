//
//  UIImageViewExtensions.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 06/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

extension UIImageView {

    func loadImage(withFilePath filePath: String?) {
        if let cachedImage = MarvelApplication.instance.imageCache.cachedImage(forKey: filePath) {
            image = cachedImage
            return
        }
        DispatchQueue.global().async {
            if let filePath = filePath, let url = URL(string: filePath), let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                MarvelApplication.instance.imageCache.set(image: image, forKey: filePath)

                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

