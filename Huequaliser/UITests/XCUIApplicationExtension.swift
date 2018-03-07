//
// Created by Igor Tarasenko on 3/7/18.
// Copyright (c) 2018 24coms. All rights reserved.
//

import XCTest

extension XCUIApplication {
    var isDisplayingOnboarding: Bool {
        return otherElements["onboardingView"].exists
    }
}
