//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import RxCocoa
import RxOptional
import RxSwift

/// Holds stack of global app states
public final class AppEnvironment {
    private static let environmentVariable: Variable<Environment> = .init(Environment())

    public static var current: Environment {
        return environmentVariable.value
    }

    public static var asDriver: Driver<Environment> {
        return environmentVariable.asDriver()
    }

    public static func pushEnvironment(_ env: Environment) {
        environmentVariable.value = env
    }

    public static func updateCurrentEnvironment(
            dependencies: DependencyContainerType? = current.dependencies,
            sceneFactory: SceneFactoryType? = current.sceneFactory
    ) {
        environmentVariable.value = Environment(
                dependencies: dependencies,
                sceneFactory: sceneFactory
        )
    }
}
