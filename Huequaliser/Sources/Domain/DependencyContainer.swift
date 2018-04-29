//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

/// Holds all app dependencies
public protocol DependencyContainerType: SpotifyServiceContainer {
    var networking: NetworkingType { get }
}

public struct DependencyContainer: DependencyContainerType {
    public let networking: NetworkingType
    public let spotifyService: SpotifyServiceType
}
