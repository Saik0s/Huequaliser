//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Foundation

/// Default way to create all dependencies
public extension DependencyContainer {
    static func resolve() -> DependencyContainer {
        let spotifySettings: SpotifySettings = SpotifySettings(
                apiURL: Constants.Spotify.apiURI,
                authorizeURI: Constants.Spotify.authorizeURI,
                tokenURI: Constants.Spotify.tokenURI,
                clientID: Constants.Spotify.clientID,
                clientSecret: Constants.Spotify.clientSecret,
                redirectURI: Constants.Spotify.redirectURI,
                scope: Constants.Spotify.scope
        )
        let networking: NetworkingType = Networking(spotifySettings: spotifySettings)

        let spotifyService: SpotifyServiceType = SpotifyService(networking: networking)

        let hueService: HueServiceType = HueService(networking: networking)

        return DependencyContainer(networking: networking, spotifyService: spotifyService, hueService: hueService)
    }
}
