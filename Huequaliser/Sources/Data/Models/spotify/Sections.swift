//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Sections: Value {
    public let start: Double?
    public let duration: Double?
    public let confidence: Int?
    public let loudness: Double?
    public let tempo: Double?
    public let tempoConfidence: Double?
    public let key: Int?
    public let keyConfidence: Double?
    public let mode: Int?
    public let modeConfidence: Double?
    public let timeSignature: Int?
    public let timeSignatureConfidence: Int?

    public enum CodingKeys: String, CodingKey {
        case start
        case duration
        case confidence
        case loudness
        case tempo
        case tempoConfidence = "tempo_confidence"
        case key
        case keyConfidence = "key_confidence"
        case mode
        case modeConfidence = "mode_confidence"
        case timeSignature = "time_signature"
        case timeSignatureConfidence = "time_signature_confidence"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(Double.self, forKey: .start)
        duration = try values.decodeIfPresent(Double.self, forKey: .duration)
        confidence = try values.decodeIfPresent(Int.self, forKey: .confidence)
        loudness = try values.decodeIfPresent(Double.self, forKey: .loudness)
        tempo = try values.decodeIfPresent(Double.self, forKey: .tempo)
        tempoConfidence = try values.decodeIfPresent(Double.self, forKey: .tempoConfidence)
        key = try values.decodeIfPresent(Int.self, forKey: .key)
        keyConfidence = try values.decodeIfPresent(Double.self, forKey: .keyConfidence)
        mode = try values.decodeIfPresent(Int.self, forKey: .mode)
        modeConfidence = try values.decodeIfPresent(Double.self, forKey: .modeConfidence)
        timeSignature = try values.decodeIfPresent(Int.self, forKey: .timeSignature)
        timeSignatureConfidence = try values.decodeIfPresent(Int.self, forKey: .timeSignatureConfidence)
    }
}
