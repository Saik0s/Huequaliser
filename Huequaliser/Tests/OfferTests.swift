//
// Created by Igor Tarasenko on 3/7/18.
// Copyright (c) 2018 24coms. All rights reserved.
//

@testable import Huequaliser
import XCTest

class OfferTests: XCTestCase {
    var banana: Banana!

    override func setUp() {
        super.setUp()
        banana = Banana()
    }

    func testOffer_whenTheBananaIsPeeled_offersTheBanana() {
        banana.peel()

        // Act: Create the string used to offer the banana.
        let message = offer(banana)

        // Assert: Verify it's the right string.
        XCTAssertEqual(message, "Hey, want a banana?")
    }

    func testOffer_whenTheBananaIsntPeeled_offersToPeelTheBanana() {
        // Act: Create the string used to offer the banana.
        let message = offer(banana)

        // Assert: Verify it's the right string.
        XCTAssertEqual(message, "Hey, want me to peel this banana for you?")
    }
}
