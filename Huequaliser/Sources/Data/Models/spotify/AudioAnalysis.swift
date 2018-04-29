//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct AudioAnalysis: Value {
    public let bars: [Bars]?
    public let beats: [Beats]?
    public let meta: Meta?
    public let sections: [Sections]?
    public let segments: [Segments]?
    public let tatums: [Tatum]?
    public let track: TrackData?

    public enum CodingKeys: String, CodingKey {
        case bars
        case beats
        case meta
        case sections
        case segments
        case tatums
        case track
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bars = try values.decodeIfPresent([Bars].self, forKey: .bars)
        beats = try values.decodeIfPresent([Beats].self, forKey: .beats)
        meta = try values.decodeIfPresent(Meta.self, forKey: .meta)
        sections = try values.decodeIfPresent([Sections].self, forKey: .sections)
        segments = try values.decodeIfPresent([Segments].self, forKey: .segments)
        tatums = try values.decodeIfPresent([Tatum].self, forKey: .tatums)
        track = try values.decodeIfPresent(TrackData.self, forKey: .track)
    }
}
