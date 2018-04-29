//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import class UIKit.UIViewController

/// Wrapper for factory functions for code completion
public struct Scene<Callbacks: ViewModelCallbacksType> {
    public typealias Factory<Callbacks> = (DependencyContainerType) -> (Callbacks, UIViewController)

    private let factory: Factory<Callbacks>

    public init(_ factory: @escaping Factory<Callbacks>) {
        self.factory = factory
    }

    public func exec(
            container: DependencyContainerType
    ) -> ((UIViewController) -> Void) -> (Callbacks, UIViewController) {
        let (sceneCallbacks, viewController) = self.factory(container)
        return { vcClosure in
            vcClosure(viewController)
            return (sceneCallbacks, viewController)
        }
    }
}

public protocol SceneFactoryType {
    @discardableResult
    func make<C>(_ factory: Scene<C>, then completion: @escaping (UIViewController) -> Void) -> (C, UIViewController)
}

public final class SceneFactory: SceneFactoryType {
    private let dependencies: DependencyContainerType

    // MARK: - Public methods

    public init(dependencies: DependencyContainerType) {
        self.dependencies = dependencies
    }

    public func make<C>(
            _ factory: Scene<C>,
            then completion: @escaping (UIViewController) -> Void
    ) -> (C, UIViewController) {
        return factory.exec(container: dependencies)(completion)
    }
}
