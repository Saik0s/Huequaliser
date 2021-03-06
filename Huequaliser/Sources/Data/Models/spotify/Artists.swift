//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Artists: Value {
    public let externalURLs: ExternalURL?
    public let href: String?
    public let id: String?
    public let name: String?
    public let type: String?
    public let uri: String?

    public enum CodingKeys: String, CodingKey {
        case externalURLs
        case href
        case id
        case name
        case type
        case uri
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        externalURLs = try values.decodeIfPresent(ExternalURL.self, forKey: .externalURLs)
        href = try values.decodeIfPresent(String.self, forKey: .href)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
    }
}
