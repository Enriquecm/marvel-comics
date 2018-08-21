//
//  MCGradientView.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 08/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCGradientView: UIView {

    var colors: [UIColor]? {
        didSet {
            if let colors = colors {
                gradientLayer.gradientColors = colors
            }
        }
    }

    fileprivate var gradientLayer: MCGradientLayer {
        return layer as? MCGradientLayer ?? MCGradientLayer()
    }

    override class var layerClass: AnyClass {
        return MCGradientLayer.self
    }
}

class MCGradientLayer: CAGradientLayer {

    var rotation: Float = 2 {
        didSet {
            configure(with: rotation)
        }
    }
    var gradientColors: [UIColor] = [] {
        didSet {
            updateColors()
        }
    }

    override init() {
        super.init()
        configure(with: rotation)
    }

    override init(layer: Any) {
        super.init(layer: layer)
        configure(with: rotation)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure(with: rotation)
    }

    private func configure(with rotation: Float) {
        updateColors()

        let a = CGFloat(powf(sinf((2 * Float.pi * ((rotation + 0.75) / 2))), 2))
        let b = CGFloat(powf(sinf((2 * Float.pi * ((rotation + 0.00) / 2))), 2))
        let c = CGFloat(powf(sinf((2 * Float.pi * ((rotation + 0.25) / 2))), 2))
        let d = CGFloat(powf(sinf((2 * Float.pi * ((rotation + 0.50) / 2))), 2))

        startPoint = CGPoint(x: a, y: b)
        endPoint = CGPoint(x: c, y: d)
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        updateColors()
    }

    private func updateColors() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.colors = gradientColors.compactMap({ $0.cgColor })
        CATransaction.commit()
    }
}
