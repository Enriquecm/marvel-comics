//
//  MCPresentationAnimator.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 08/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var openingFrame: CGRect?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to),
            let snapshotView = toViewController.view.resizableSnapshotView(from: toViewController.view.frame, afterScreenUpdates: true, withCapInsets: .zero),
            let openingFrame = openingFrame else {
                transitionContext.completeTransition(true)
                return
        }

        let containerView = transitionContext.containerView
        let fromViewFrame = fromViewController.view.frame

        UIGraphicsBeginImageContext(fromViewFrame.size)
        fromViewController.view.drawHierarchy(in: fromViewFrame, afterScreenUpdates: true)
        _ = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        snapshotView.frame = openingFrame
        containerView.addSubview(snapshotView)

        toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: [], animations: {
            snapshotView.frame = fromViewController.view.frame
        }) { (finished) in
            snapshotView.removeFromSuperview()
            toViewController.view.alpha = 1.0

            transitionContext.completeTransition(finished)
        }
    }
}
