//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public extension Scene where Callbacks == AppFlowViewModel {
    static let appFlow: Scene = .init {
        let viewModel: AppFlowViewModel = AppFlowViewModel(dependencies: $0)
        let viewController = AppFlowController()
        viewController.reactor = viewModel
        return (viewModel, viewController)
    }
}
