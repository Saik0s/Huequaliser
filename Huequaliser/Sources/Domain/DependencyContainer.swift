//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

/// Holds all app dependencies
// sourcery:begin: PropertiesProtocolPrefix = "", PropertiesProtocolSuffix = Container
public struct DependencyContainer: AutoPropertiesProtocol {
    public let networking: NetworkingType
    public let spotifyService: SpotifyServiceType
    public let hueService: HueServiceType
    public var spotifyNetworking: SpotifyNetworkingType { return networking }
    public var hueNetworking: HueNetworkingType { return networking }
}

// sourcery:end
