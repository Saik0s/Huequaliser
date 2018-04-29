//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Moya

public enum HueAPI {
    case getBridgesFromNUPnP

    case createUser(deviceType: String, clientKey: Bool)
    case getAllGroups(username: String)
    case createGroup(username: String, name: String, type: String, class: String, lights: [Int])
}

extension HueAPI: SugarTargetType {
    public var route: Route {
        switch self {
            case .getBridgesFromNUPnP:
                return .get("/api/nupnp")
            case .createUser:
                return .post("/api")
            case let .getAllGroups(username):
                return .get("/api/\(username)/groups")
            case let .createGroup(username, _, _, _, _):
                return .get("/api/\(username)/groups")
        }
    }

    public var parameters: Parameters? {
        switch self {
            case let .createUser(deviceType, clientKey):
                return JSONEncoding() => [
                    "devicetype": deviceType,
                    "generateclientkey": clientKey
                ]

            case let .createGroup(_, name, type, `class`, lights):
                return JSONEncoding() => [
                    "name": name,
                    "type": type,
                    "class": `class`,
                    "lights": lights
                ]

            default:
                return nil
        }
    }
}
