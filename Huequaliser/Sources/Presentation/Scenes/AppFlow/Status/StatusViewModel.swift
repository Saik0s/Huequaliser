//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import ReactorKit
import RxSwift

public final class StatusViewModel: BaseViewModelType<SpotifyServiceContainer & HueServiceContainer> {
    public enum Callbacks {
    }

    public enum Action {
        case getCurrentlyPlaying
        case searchForBridges
    }

    public enum Mutation {
        case setCurrentTrack(CurrentlyPlaying)
        case setBridges([HueBridge])
    }

    public struct State {
        var currentTrack: CurrentlyPlaying?
        var bridges: [HueBridge] = []
    }

    public let initialState = State()

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .getCurrentlyPlaying:
                return spotifyService.getCurrentPlayingTrack().map { Mutation.setCurrentTrack($0) }
            case .searchForBridges:
                return hueService.searchForBridges().map { Mutation.setBridges($0) }
        }
    }

    public func reduce(state oldState: State, mutation: Mutation) -> State {
        switch mutation {
            case let .setCurrentTrack(track):
                return State(currentTrack: track, bridges: oldState.bridges)
            case let .setBridges(bridges):
                return State(currentTrack: oldState.currentTrack, bridges: bridges)
        }
    }
}

private extension StatusViewModel {
    var spotifyService: SpotifyServiceType { return dependencies.spotifyService }
    var hueService: HueServiceType { return dependencies.hueService }
}
