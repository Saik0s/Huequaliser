//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Environment {
    public let dependencies: DependencyContainerType?
    public let sceneFactory: SceneFactoryType?
    public let activityIndicator: ActivityIndicator = ActivityIndicator()
    public let errorTracker: RxErrorTracker = RxErrorTracker()
}

public extension Environment {
    init() {
        self.init(
                dependencies: nil,
                sceneFactory: nil
                // activityIndicator: ActivityIndicator(),
                // errorTracker: RxErrorTracker()
        )
    }
}
