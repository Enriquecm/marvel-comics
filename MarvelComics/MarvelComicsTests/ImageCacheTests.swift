//
//  ImageCacheTests.swift
//  MarvelComicsTests
//
//  Created by Enrique Melgarejo on 09/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import XCTest
@testable import MarvelComics

class ImageCacheTests: XCTestCase {

    var imageCache: MCImageCache!

    override func setUp() {
        super.setUp()
        imageCache = MCImageCache()
    }

    func testUncachedImage() {
        let image = imageCache.cachedImage(forKey: "uncachedKey")
        XCTAssertNil(image, "The image should be nil.")
    }

    func testCachedImage() {
        let image = UIImage(named: "image-character")
        imageCache.set(image: image, forKey: "cachedKey")

        let imageCached = imageCache.cachedImage(forKey: "cachedKey")
        XCTAssertEqual(image, imageCached, "The Image should be the same of the image cached")
    }
    
}
