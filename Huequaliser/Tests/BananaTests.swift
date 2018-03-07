//
// Created by Igor Tarasenko on 3/7/18.
// Copyright (c) 2018 24coms. All rights reserved.
//

@testable import Huequaliser
import XCTest

class BananaTests: XCTestCase {
    func testPeel_makesTheBananaEdible() {
        // Arrange: Create the banana we'll be peeling.
        let banana = Banana()

        // Act: Peel the banana.
        banana.peel()

        // Assert: Verify that the banana is now edible.
        XCTAssertTrue(banana.isEdible)
    }
}
