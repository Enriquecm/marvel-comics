//
//  MCDismissalAnimator.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 08/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var openingFrame: CGRect?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let snapshotView = fromVC.view.resizableSnapshotView(from: fromVC.view.bounds, afterScreenUpdates: true, withCapInsets: .zero),
            let openingFrame = openingFrame else {
                transitionContext.completeTransition(true)
                return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotView)

        fromVC.view.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            snapshotView.frame = openingFrame
            snapshotView.alpha = 0.0
        }) { (finished) in
            snapshotView.removeFromSuperview()
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}

