//
// Created by Igor Tarasenko on 3/7/18.
// Copyright (c) 2018 24coms. All rights reserved.
//

import Foundation
/** A delicious banana. Tastes better if you peel it first. */
public class Banana {
    private var isPeeled = false

    /** Peels the banana. */
    public func peel() {
        isPeeled = true
    }

    /** You shouldn't eat a banana unless it's been peeled. */
    public var isEdible: Bool {
        return isPeeled
    }
}
