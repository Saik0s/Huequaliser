//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct HueBridge: Value {
    public let id: String
    public let ipAddress: String

    public enum CodingKeys: String, CodingKey {
        case id
        case ipAddress = "internalipaddress"
    }
}
