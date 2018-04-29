//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

/// Holds all app dependencies
public protocol DependencyContainerType: SpotifyServiceContainer, HueServiceContainer {
    var networking: NetworkingType { get }
}

public struct DependencyContainer: DependencyContainerType {
    public let networking: NetworkingType
    public let spotifyService: SpotifyServiceType
    public let hueService: HueServiceType
}
