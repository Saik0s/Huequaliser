//
// Created by Igor Tarasenko on 3/7/18.
// Copyright (c) 2018 24coms. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    var userDefaults = UserDefaults.standard

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard presentedViewController == nil else {
            return
        }

        if !userDefaults.onboardingCompleted {
            let onboardingVC = OnboardingViewController()
            present(onboardingVC, animated: false)
        }
    }
}
