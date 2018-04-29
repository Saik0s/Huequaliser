//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import UIKit

@UIApplicationMain internal class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?

    internal func application(
            _: UIApplication,
            didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        let dependencies: DependencyContainerType = DependencyContainer.resolve()
        let sceneFactory: SceneFactoryType = SceneFactory(dependencies: dependencies)
        AppEnvironment.updateCurrentEnvironment(dependencies: dependencies, sceneFactory: sceneFactory)

        sceneFactory.make(.appFlow) { controller in
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = controller
            window.makeKeyAndVisible()
            self.window = window
        }

        return true
    }

    func application(
            _: UIApplication,
            open url: URL,
            options _: [UIApplicationOpenURLOptionsKey: Any]
    ) -> Bool {
        try? AppEnvironment.current.dependencies.require().networking.handleRedirect(url: url)
        return true
    }
}
