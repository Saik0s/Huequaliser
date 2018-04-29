//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Segments: Value {
    public let start: Double?
    public let duration: Double?
    public let confidence: Double?
    public let loudnessStart: Double?
    public let loudnessMaxTime: Double?
    public let loudnessMax: Double?
    public let loudnessEnd: Int?
    public let pitches: [Double]?
    public let timbre: [Double]?

    public enum CodingKeys: String, CodingKey {
        case start
        case duration
        case confidence
        case loudnessStart = "loudness_start"
        case loudnessMaxTime = "loudness_max_time"
        case loudnessMax = "loudness_max"
        case loudnessEnd = "loudness_end"
        case pitches
        case timbre
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(Double.self, forKey: .start)
        duration = try values.decodeIfPresent(Double.self, forKey: .duration)
        confidence = try values.decodeIfPresent(Double.self, forKey: .confidence)
        loudnessStart = try values.decodeIfPresent(Double.self, forKey: .loudnessStart)
        loudnessMaxTime = try values.decodeIfPresent(Double.self, forKey: .loudnessMaxTime)
        loudnessMax = try values.decodeIfPresent(Double.self, forKey: .loudnessMax)
        loudnessEnd = try values.decodeIfPresent(Int.self, forKey: .loudnessEnd)
        pitches = try values.decodeIfPresent([Double].self, forKey: .pitches)
        timbre = try values.decodeIfPresent([Double].self, forKey: .timbre)
    }
}
