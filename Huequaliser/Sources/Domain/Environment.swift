//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public struct Environment: AutoInitable, Codable {
    public let dependencies: DependencyContainer?
    public let sceneFactory: SceneFactoryType?
    // sourcery: default="ActivityIndicator()"
    public let activityIndicator: ActivityIndicator
    // sourcery: default="RxErrorTracker()"
    public let errorTracker: RxErrorTracker
    public let hueBridge: HueBridge?
    public let hueUser: HueUser?

    public enum CodingKeys: String, CodingKey {
        case hueBridge
        case hueUser
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let hueBridge = try values.decodeIfPresent(HueBridge.self, forKey: .hueBridge)
        let hueUser = try values.decodeIfPresent(HueUser.self, forKey: .hueUser)
        self.init(hueBridge: hueBridge, hueUser: hueUser)
        dlog(hueBridge)
    }

    // sourcery:inline:Environment.AutoInitable
    public init(
            dependencies: DependencyContainer? = nil,
            sceneFactory: SceneFactoryType? = nil,
            activityIndicator: ActivityIndicator = ActivityIndicator(),
            errorTracker: RxErrorTracker = RxErrorTracker(),
            hueBridge: HueBridge? = nil,
            hueUser: HueUser? = nil
    ) {
        self.dependencies = dependencies
        self.sceneFactory = sceneFactory
        self.activityIndicator = activityIndicator
        self.errorTracker = errorTracker
        self.hueBridge = hueBridge
        self.hueUser = hueUser
    dlog(hueBridge)
    }

    // sourcery:end
}
