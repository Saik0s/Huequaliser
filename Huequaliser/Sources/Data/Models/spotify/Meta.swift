//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Meta: Value {
    public let analyzerVersion: String?
    public let platform: String?
    public let detailedStatus: String?
    public let statusCode: Int?
    public let timestamp: Int?
    public let analysisTime: Double?
    public let inputProcess: String?

    public enum CodingKeys: String, CodingKey {
        case analyzerVersion = "analyzer_version"
        case platform
        case detailedStatus = "detailed_status"
        case statusCode = "status_code"
        case timestamp
        case analysisTime = "analysis_time"
        case inputProcess = "input_process"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        analyzerVersion = try values.decodeIfPresent(String.self, forKey: .analyzerVersion)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        detailedStatus = try values.decodeIfPresent(String.self, forKey: .detailedStatus)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
        analysisTime = try values.decodeIfPresent(Double.self, forKey: .analysisTime)
        inputProcess = try values.decodeIfPresent(String.self, forKey: .inputProcess)
    }
}
