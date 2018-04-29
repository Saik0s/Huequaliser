//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct HueUser: Value {
    public let username: String
    public let clientKey: String

    public enum CodingKeys: String, CodingKey {
        case username
        case clientKey = "clientkey"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decode(String.self, forKey: .username)
        clientKey = try values.decode(String.self, forKey: .clientKey)
    }
}
