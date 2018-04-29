//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import ReactorKit
import RxSwift

// public final class StatusViewModel: BaseViewModel<SpotifyServiceContainer & HueServiceContainer>, BaseViewModelType {
public final class StatusViewModel: Reactor, ViewModelCallbacksType {
    public typealias Dependencies = SpotifyServiceContainer & HueServiceContainer

    public enum Callbacks {
    }

    public enum Action {
        case getCurrentlyPlaying
        case searchForBridges
        case createNewUser
        case getGroups
    }

    public enum Mutation {
        case setCurrentTrack(CurrentlyPlaying)
        case setBridges([HueBridge])
        case setNewUser(HueUser)
        case setGroups(Groups)
    }

    public struct State: Then {
        var currentTrack: CurrentlyPlaying?
        var bridges: [HueBridge] = []
        var user: HueUser?
        var groups: Groups = Groups(groups: [])
    }

    public let initialState = State().with { state in
        state.user = AppEnvironment.current.hueUser
        state.bridges = AppEnvironment.current.hueBridge.map { [$0] } ?? []
    }

    public private(set) var callback: PublishSubject<Callbacks> = .init()
    internal let dependencies: Dependencies

    public required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .getCurrentlyPlaying:
                return spotifyService.getCurrentPlayingTrack()
                        .trackError(AppEnvironment.current.errorTracker)
                        .trackActivity(AppEnvironment.current.activityIndicator)
                        .map { Mutation.setCurrentTrack($0) }
            case .searchForBridges:
                return hueService.searchForBridges()
                        .trackError(AppEnvironment.current.errorTracker)
                        .trackActivity(AppEnvironment.current.activityIndicator)
                        .map { Mutation.setBridges($0) }
            case .createNewUser:
                if let user = AppEnvironment.current.hueUser { return .just(Mutation.setNewUser(user)) }
                return hueService.createNewUser()
                        .trackError(AppEnvironment.current.errorTracker)
                        .trackActivity(AppEnvironment.current.activityIndicator)
                        .map { Mutation.setNewUser($0) }
            case .getGroups:
                let username: String = currentState.user.require().username
                return hueService.getAllGroups(for: username)
                        .trackError(AppEnvironment.current.errorTracker)
                        .trackActivity(AppEnvironment.current.activityIndicator)
                        .map { Mutation.setGroups($0) }
        }
    }

    public func reduce(state oldState: State, mutation: Mutation) -> State {
        switch mutation {
            case let .setCurrentTrack(track):
                return oldState.with { $0.currentTrack = track }
            case let .setBridges(bridges):
                return oldState.with { $0.bridges = bridges }
            case let .setNewUser(user):
                return oldState.with { $0.user = user }
            case let .setGroups(groups):
                return oldState.with { $0.groups = groups }
        }
    }

    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return mutation.do(onNext: {
            if case let Mutation.setBridges(bridges) = $0 {
                AppEnvironment.updateCurrentEnvironment(hueBridge: bridges.first)
            } else if case let Mutation.setNewUser(user) = $0 {
                AppEnvironment.updateCurrentEnvironment(hueUser: user)
            } else if case let Mutation.setGroups(groups) = $0 {
                // AppEnvironment.updateCurrentEnvironment(hueUser: groups)
            }
        }).do(onNext: { dlog($0) }, onError: { dlog($0) })
    }

    public func transform(action: Observable<Action>) -> Observable<Action> {
        return action.do(onNext: { dlog($0) }, onError: { dlog($0) })
    }

    public func transform(state: Observable<State>) -> Observable<State> {
        return state.do(onNext: { dlog($0) }, onError: { dlog($0) })
    }
}

private extension StatusViewModel {
    var spotifyService: SpotifyServiceType { return dependencies.spotifyService }
    var hueService: HueServiceType { return dependencies.hueService }
}
