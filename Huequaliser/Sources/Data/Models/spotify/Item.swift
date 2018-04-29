//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Item: Value {
    public let album: Album?
    public let artists: [Artists]?
    public let availableMarkets: [String]?
    public let discNumber: Int?
    public let durationMS: Int?
    public let explicit: Bool
    public let externalIDs: ExternalID?
    public let externalURLs: ExternalURL?
    public let href: String?
    public let id: String?
    public let name: String?
    public let popularity: Int?
    public let previewURL: String?
    public let trackNumber: Int?
    public let type: String?
    public let uri: String?

    public enum CodingKeys: String, CodingKey {
        case album
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDs
        case externalURLs
        case href
        case id
        case name
        case popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type
        case uri
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        album = try values.decodeIfPresent(Album.self, forKey: .album)
        artists = try values.decodeIfPresent([Artists].self, forKey: .artists)
        availableMarkets = try values.decodeIfPresent([String].self, forKey: .availableMarkets)
        discNumber = try values.decodeIfPresent(Int.self, forKey: .discNumber)
        durationMS = try values.decodeIfPresent(Int.self, forKey: .durationMS)
        explicit = try values.decodeIfPresent(Bool.self, forKey: .explicit) ?? false
        externalIDs = try values.decodeIfPresent(ExternalID.self, forKey: .externalIDs)
        externalURLs = try values.decodeIfPresent(ExternalURL.self, forKey: .externalURLs)
        href = try values.decodeIfPresent(String.self, forKey: .href)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        popularity = try values.decodeIfPresent(Int.self, forKey: .popularity)
        previewURL = try values.decodeIfPresent(String.self, forKey: .previewURL)
        trackNumber = try values.decodeIfPresent(Int.self, forKey: .trackNumber)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
    }
}
