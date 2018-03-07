//
// Created by Igor Tarasenko on 3/7/18.
// Copyright (c) 2018 24coms. All rights reserved.
//

import Foundation

extension UserDefaults {
    var onboardingCompleted: Bool {
        get { return bool(forKey: #function) }
        set { setValue(newValue, forKey: #function) }
    }
}
