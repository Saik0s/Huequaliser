//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import ReactorKit
import RxSwift

public final class StatusViewModel: BaseViewModelType<SpotifyServiceContainer> {
    public enum Callbacks {
    }

    public enum Action {
        case getCurrentTrack
    }

    public enum Mutation {
        case setCurrentTrack(String)
    }

    public struct State {
        var currentTrack: String?
    }

    public let initialState = State()

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .getCurrentTrack:
                return dependencies.spotifyService.getCurrentPlayingTrack().map { Mutation.setCurrentTrack($0) }
        }
    }

    public func reduce(state _: State, mutation: Mutation) -> State {
        switch mutation {
            case let .setCurrentTrack(track):
                return State(currentTrack: track)
        }
    }
}
