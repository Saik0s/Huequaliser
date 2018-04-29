//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct ExternalURL: Value {
    public let spotify: String?

    public enum CodingKeys: String, CodingKey {
        case spotify
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        spotify = try values.decodeIfPresent(String.self, forKey: .spotify)
    }
}
