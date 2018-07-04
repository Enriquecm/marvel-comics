//
//  MCViewController.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCViewController: UIViewController {
    // MARK: - Properties
    private(set) var baseViewModel: MCViewModel?

    class var identifier: String {
        return String(describing: self)
    }

    class var storyboardName: String {
        return MCIdentifiers.Storyboard.Main.name
    }

    private class func initializeViewController() -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }

    class func initializeViewController(viewModel: MCViewModel, withNavigation: Bool = false) -> UIViewController {
        let vc = initializeViewController()

        if let vc = vc as? MCViewController {
            vc.baseViewModel = viewModel
        }

        if withNavigation {
            let navigation = UINavigationController(rootViewController: vc)
            return navigation
        } else {
            return vc
        }
    }

}

