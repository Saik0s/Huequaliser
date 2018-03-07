//
//  Created by Igor Tarasenko on 2/27/18.
//  Copyright © 2018 24coms. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if CommandLine.arguments.contains("--uitesting") {
            resetState()
        }

        let mainVC = MainViewController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = mainVC
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}

private extension AppDelegate {
    func resetState() {
        print("reset")
        if let defaultsName = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: defaultsName)
        }
    }
}
