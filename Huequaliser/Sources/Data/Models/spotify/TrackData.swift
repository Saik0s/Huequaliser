//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct TrackData: Value {
    public let numSamples: String?
    public let duration: Double?
    public let sampleMd5: String?
    public let offsetSeconds: Int?
    public let windowSeconds: Int?
    public let analysisSampleRate: Int?
    public let analysisChannels: Int?
    public let endOfFadeIn: Int?
    public let startOfFadeOut: Double?
    public let loudness: Double?
    public let tempo: Double?
    public let tempoConfidence: Double?
    public let timeSignature: Int?
    public let timeSignatureConfidence: Int?
    public let key: Int?
    public let keyConfidence: Double?
    public let mode: Int?
    public let modeConfidence: Double?
    public let codeString: String?
    public let codeVersion: Double?
    public let echoPrintString: String?
    public let echoPrintVersion: Double?
    public let synchString: String?
    public let synchVersion: Int?
    public let rhythmString: String?
    public let rhythmVersion: Int?

    public enum CodingKeys: String, CodingKey {
        case numSamples = "num_samples"
        case duration
        case sampleMd5 = "sample_md5"
        case offsetSeconds = "offset_seconds"
        case windowSeconds = "window_seconds"
        case analysisSampleRate = "analysis_sample_rate"
        case analysisChannels = "analysis_channels"
        case endOfFadeIn = "end_of_fade_in"
        case startOfFadeOut = "start_of_fade_out"
        case loudness
        case tempo
        case tempoConfidence = "tempo_confidence"
        case timeSignature = "time_signature"
        case timeSignatureConfidence = "time_signature_confidence"
        case key
        case keyConfidence = "key_confidence"
        case mode
        case modeConfidence = "mode_confidence"
        case codeString = "codestring"
        case codeVersion = "code_version"
        case echoPrintString = "echoprintstring"
        case echoPrintVersion = "echoprint_version"
        case synchString = "synchstring"
        case synchVersion = "synch_version"
        case rhythmString = "rhythmstring"
        case rhythmVersion = "rhythm_version"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        numSamples = try values.decodeIfPresent(String.self, forKey: .numSamples)
        duration = try values.decodeIfPresent(Double.self, forKey: .duration)
        sampleMd5 = try values.decodeIfPresent(String.self, forKey: .sampleMd5)
        offsetSeconds = try values.decodeIfPresent(Int.self, forKey: .offsetSeconds)
        windowSeconds = try values.decodeIfPresent(Int.self, forKey: .windowSeconds)
        analysisSampleRate = try values.decodeIfPresent(Int.self, forKey: .analysisSampleRate)
        analysisChannels = try values.decodeIfPresent(Int.self, forKey: .analysisChannels)
        endOfFadeIn = try values.decodeIfPresent(Int.self, forKey: .endOfFadeIn)
        startOfFadeOut = try values.decodeIfPresent(Double.self, forKey: .startOfFadeOut)
        loudness = try values.decodeIfPresent(Double.self, forKey: .loudness)
        tempo = try values.decodeIfPresent(Double.self, forKey: .tempo)
        tempoConfidence = try values.decodeIfPresent(Double.self, forKey: .tempoConfidence)
        timeSignature = try values.decodeIfPresent(Int.self, forKey: .timeSignature)
        timeSignatureConfidence = try values.decodeIfPresent(Int.self, forKey: .timeSignatureConfidence)
        key = try values.decodeIfPresent(Int.self, forKey: .key)
        keyConfidence = try values.decodeIfPresent(Double.self, forKey: .keyConfidence)
        mode = try values.decodeIfPresent(Int.self, forKey: .mode)
        modeConfidence = try values.decodeIfPresent(Double.self, forKey: .modeConfidence)
        codeString = try values.decodeIfPresent(String.self, forKey: .codeString)
        codeVersion = try values.decodeIfPresent(Double.self, forKey: .codeVersion)
        echoPrintString = try values.decodeIfPresent(String.self, forKey: .echoPrintString)
        echoPrintVersion = try values.decodeIfPresent(Double.self, forKey: .echoPrintVersion)
        synchString = try values.decodeIfPresent(String.self, forKey: .synchString)
        synchVersion = try values.decodeIfPresent(Int.self, forKey: .synchVersion)
        rhythmString = try values.decodeIfPresent(String.self, forKey: .rhythmString)
        rhythmVersion = try values.decodeIfPresent(Int.self, forKey: .rhythmVersion)
    }
}
