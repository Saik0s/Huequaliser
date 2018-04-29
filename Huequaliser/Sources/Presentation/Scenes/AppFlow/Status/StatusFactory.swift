//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public extension Scene where Callbacks == StatusViewModel {
    static let status: Scene = .init {
        let viewModel: StatusViewModel = StatusViewModel(dependencies: $0)
        let viewController: StatusViewController = .init(node: StatusNode())
        viewController.reactor = viewModel
        return (viewModel, viewController)
    }
}
