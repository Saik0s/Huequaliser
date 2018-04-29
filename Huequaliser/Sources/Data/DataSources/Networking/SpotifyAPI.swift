//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public enum SpotifyAPI {
    case getCurrentlyPlaying
}

extension SpotifyAPI: SugarTargetType {
    public var route: Route {
        switch self {
            case .getCurrentlyPlaying:
                return .get("/me/player/currently-playing")
        }
    }

    public var parameters: Parameters? {
        switch self {
            case .getCurrentlyPlaying:
                return nil
        }
    }
}
