//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct CurrentlyPlaying: Value {
    public let context: Context?
    public let timestamp: Int?
    public let progressMS: Int?
    public let isPlaying: Bool
    public let item: Item?

    public enum CodingKeys: String, CodingKey {
        case context
        case timestamp
        case progressMS = "progress_ms"
        case isPlaying = "is_playing"
        case item
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        context = try values.decodeIfPresent(Context.self, forKey: .context)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
        progressMS = try values.decodeIfPresent(Int.self, forKey: .progressMS)
        isPlaying = try values.decodeIfPresent(Bool.self, forKey: .isPlaying) ?? false
        item = try values.decodeIfPresent(Item.self, forKey: .item)
    }
}
