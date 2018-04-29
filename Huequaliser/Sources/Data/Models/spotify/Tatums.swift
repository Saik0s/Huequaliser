//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Tatum: Value {
    public let start: Double?
    public let duration: Double?
    public let confidence: Double?

    public enum CodingKeys: String, CodingKey {
        case start
        case duration
        case confidence
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(Double.self, forKey: .start)
        duration = try values.decodeIfPresent(Double.self, forKey: .duration)
        confidence = try values.decodeIfPresent(Double.self, forKey: .confidence)
    }
}
