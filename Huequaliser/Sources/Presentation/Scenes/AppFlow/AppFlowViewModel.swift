//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import ReactorKit
import RxSwift

public final class AppFlowViewModel: BaseViewModel<SpotifyServiceContainer>, BaseViewModelType {
    public enum Callbacks {
    }

    public enum Action {
        // case didFinishLoading
    }

    public enum Mutation {
        // case setLoading(Bool)
        // case setError(Error)
    }

    public struct State {
        var isLoading: Bool = false
        var error: Error?
    }

    public let initialState = State()
    public private(set) var callback: RxSwift.PublishSubject<Callbacks> = .init()

    // public func mutate(action: Action) -> Observable<Mutation> {
    //
    // }
    //
    // public func reduce(state: State, mutation: Mutation) -> State {
    //
    // }
}
