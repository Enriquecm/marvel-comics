//
//  MCSplashViewController.swift
//  MarvelComics
//
//  Created by Enrique Melgarejo on 03/07/18.
//  Copyright © 2018 choynowski. All rights reserved.
//

import UIKit

class MCSplashViewController: MCViewController {

    private var timer: Timer?
    private var timeIntervalToDismiss: TimeInterval = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: timeIntervalToDismiss, target: self, selector: #selector(finishSplashPresentation), userInfo: nil, repeats: false)
    }

    @objc
    private func finishSplashPresentation() {
        MarvelApplication.instance.router.goToNextScreen()
    }
}
