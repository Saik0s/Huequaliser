//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Album: Value {
    public let albumType: String?
    public let artists: [Artists]?
    public let availableMarkets: [String]?
    public let externalURLs: ExternalURL?
    public let href: String?
    public let id: String?
    public let images: [Images]?
    public let name: String?
    public let type: String?
    public let uri: String?

    public enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalURLs
        case href
        case id
        case images
        case name
        case type
        case uri
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        albumType = try values.decodeIfPresent(String.self, forKey: .albumType)
        artists = try values.decodeIfPresent([Artists].self, forKey: .artists)
        availableMarkets = try values.decodeIfPresent([String].self, forKey: .availableMarkets)
        externalURLs = try values.decodeIfPresent(ExternalURL.self, forKey: .externalURLs)
        href = try values.decodeIfPresent(String.self, forKey: .href)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
    }
}
