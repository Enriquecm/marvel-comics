//
//  MCTransitionDelegate.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 08/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var openingFrame: CGRect?

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = MCPresentationAnimator()
        presentationAnimator.openingFrame = openingFrame
        return presentationAnimator
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimator = MCDismissalAnimator()
        dismissAnimator.openingFrame = openingFrame
        return dismissAnimator
    }
}
