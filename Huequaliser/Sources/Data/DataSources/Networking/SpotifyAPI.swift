//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public enum SpotifyAPI {
    case getCurrentTrack
}

extension SpotifyAPI: SugarTargetType {
    public var route: Route {
        switch self {
            case .getCurrentTrack:
                return .get("/me/player/currently-playing")
        }
    }

    public var parameters: Parameters? {
        switch self {
            case .getCurrentTrack:
                return nil
        }
    }
}
