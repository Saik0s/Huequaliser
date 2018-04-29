//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Context: Value {
    public let externalURLs: ExternalURL?
    public let href: String?
    public let type: String?
    public let uri: String?

    public enum CodingKeys: String, CodingKey {
        case externalURLs
        case href
        case type
        case uri
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        externalURLs = try values.decodeIfPresent(ExternalURL.self, forKey: .externalURLs)
        href = try values.decodeIfPresent(String.self, forKey: .href)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
    }
}
