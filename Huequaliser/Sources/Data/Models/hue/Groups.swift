//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Foundation

public struct Groups: Value {
    public struct GroupKey: CodingKey {
        public var stringValue: String
        public var intValue: Int?

        public init?(stringValue: String) {
            intValue = Int(stringValue)
            self.stringValue = stringValue
        }

        public init?(intValue: Int) {
            self.intValue = intValue
            stringValue = "\(intValue)"
        }
    }

    public struct Group: Value {
        public struct Action: Value {
            public let on: Bool
            public let bri: Int?
            public let hue: Int?
            public let sat: Int?
            public let effect: String?
            public let xy: [Double]?
            public let ct: Int?
            public let alert: String?
            public let colorMode: String?
        }

        public struct Info: Value {
            public let name: String?
            public let lights: [String]?
            public let type: String?
            public let action: Action?
        }

        public let id: Int
        public let data: Info
    }

    public let groups: [Group]
}

public extension Groups {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GroupKey.self)

        var groups: [Group] = []
        for key in container.allKeys {
            let data: Group.Info = try container.decode(Group.Info.self, forKey: key)
            groups.append(Group(id: key.intValue ?? 0, data: data))
        }

        self.groups = groups
    }
}

public extension Groups.Group.Action {
    enum CodingKeys: String, CodingKey {
        case on
        case bri
        case hue
        case sat
        case effect
        case xy
        case ct
        case alert
        case colorMode = "colormode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        on = try values.decodeIfPresent(Bool.self, forKey: .on) ?? false
        bri = try values.decodeIfPresent(Int.self, forKey: .bri)
        hue = try values.decodeIfPresent(Int.self, forKey: .hue)
        sat = try values.decodeIfPresent(Int.self, forKey: .sat)
        effect = try values.decodeIfPresent(String.self, forKey: .effect)
        xy = try values.decodeIfPresent([Double].self, forKey: .xy)
        ct = try values.decodeIfPresent(Int.self, forKey: .ct)
        alert = try values.decodeIfPresent(String.self, forKey: .alert)
        colorMode = try values.decodeIfPresent(String.self, forKey: .colorMode)
    }
}
