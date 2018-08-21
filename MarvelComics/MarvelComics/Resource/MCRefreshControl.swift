//
//  MCRefreshControl.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 06/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

final class MCRefreshControl: UIRefreshControl {

    private let endRefreshingDelay: TimeInterval = 0.5

    override func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + endRefreshingDelay) {
            super.endRefreshing()
        }
    }
}

