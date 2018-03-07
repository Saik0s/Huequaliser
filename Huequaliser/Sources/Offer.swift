//
// Created by Igor Tarasenko on 3/7/18.
// Copyright (c) 2018 24coms. All rights reserved.
//

/** Given a banana, returns a string that can be used to offer someone the banana. */
public func offer(_ banana: Banana) -> String {
    if banana.isEdible {
        return "Hey, want a banana?"
    } else {
        return "Hey, want me to peel this banana for you?"
    }
}
