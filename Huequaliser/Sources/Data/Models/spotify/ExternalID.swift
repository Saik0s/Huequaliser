//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct ExternalID: Value {
    public let isrc: String?

    public enum CodingKeys: String, CodingKey {
        case isrc
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isrc = try values.decodeIfPresent(String.self, forKey: .isrc)
    }
}
