//
//  MCRouter.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

enum MCAppState {
    case splashScreen
    case characters
}

final class MCRouter: NSObject {

    internal var currentState = MCAppState.splashScreen

    private func changeRootViewController(forIdentifier identifier: String, storyboardName: String) {

        guard let appDelegate = UIApplication.shared.delegate,
            let window = appDelegate.window else { return }

        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let desiredViewController = storyboard.instantiateViewController(withIdentifier: identifier)

        if let snapshot: UIView = (window?.snapshotView(afterScreenUpdates: true)) {

            desiredViewController.view.addSubview(snapshot)
            window?.rootViewController = desiredViewController

            UIView.animate(withDuration: 0.3, animations: {() in
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { (finished: Bool) in
                if finished {
                    snapshot.removeFromSuperview()
                }
            })
        }
    }

    func goToNextScreen() {
        switch currentState {
        case .splashScreen:
            MCLog(from: "ROUTER", title: "SplashScreen")
            goToState(.characters)
        case .characters:
            MCLog(from: "ROUTER", title: "Characters")
        }
    }

    func goToState(_ state: MCAppState) {
        currentState = state
        switch state {
        case .splashScreen:
            changeRootViewController(forIdentifier: MCIdentifiers.RootViewController.splash, storyboardName: MCIdentifiers.Storyboard.Main.name)
        case .characters:
            changeRootViewController(forIdentifier: MCIdentifiers.RootViewController.charactersNavigation, storyboardName: MCIdentifiers.Storyboard.Main.name)
        }
    }
}

