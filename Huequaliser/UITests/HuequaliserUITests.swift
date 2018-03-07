//
//  Created by Igor Tarasenko on 2/27/18.
//  Copyright © 2018 24coms. All rights reserved.
//

@testable import Huequaliser
import XCTest

class HuequaliserUITests: XCTestCase {
    var app: XCUIApplication!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()

        // Since UI tests are more expensive to run, it's
        // usually a good idea to exit if a failure was encountered
        continueAfterFailure = false

        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }

    // MARK: - Tests

    func testGoingThroughOnboarding() {
        app.launch()

        // Make sure we're displaying onboarding
        XCTAssertTrue(app.isDisplayingOnboarding)

        // Swipe left three times to go through the pages
        app.swipeLeft()
        app.swipeLeft()
        app.swipeLeft()

        // Tap the "Done" button
        app.buttons["Done"].tap()

        // Onboarding should no longer be displayed
        XCTAssertFalse(app.isDisplayingOnboarding)
    }
}
