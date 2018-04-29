//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Moya
import RxMoya
import RxSwift

///
/// Retrieve information from spotify
///
public protocol SpotifyServiceType {
    func getCurrentPlayingTrack() -> Observable<CurrentlyPlaying>
}

public protocol SpotifyServiceContainer {
    var spotifyService: SpotifyServiceType { get }
}

// MARK: - SpotifyServiceType implementation

public final class SpotifyService: SpotifyServiceType {

    // MARK: - Public properties

    // MARK: - Private properties

    private let networking: NetworkingType

    // MARK: - Public methods

    internal init(networking: NetworkingType) {
        self.networking = networking
    }

    public func getCurrentPlayingTrack() -> Observable<CurrentlyPlaying> {
        // return networking.request(.getCurrentTrack)
        return networking.mappingRequest(CurrentlyPlaying.self, .getCurrentlyPlaying)
    }
}
