//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Foundation
import RxCocoa
import RxOptional
import RxSwift
import Socket

public final class HueService: AutoInterface {
    private let networking: HueNetworkingType

    internal init(networking: HueNetworkingType) {
        self.networking = networking
    }

    // MARK: - Public methods

    public func searchForBridges() -> Observable<[HueBridge]> {
        return networking.hueMappingRequest([HueBridge].self, .getBridgesFromNUPnP)
    }

    public func createNewUser() -> Observable<HueUser> {
        let deviceType: String = "com.huequaliser#ios igor"
        return networking.hueMappingRequest(
                [[String: HueUser]].self,
                .createUser(deviceType: deviceType, clientKey: true)
                // atKeyPath: "success"
        ).map { $0.first?.first?.value }.filterNil()
    }

    public func getAllGroups(for user: String) -> Observable<Groups> {
        return networking.hueMappingRequest(Groups.self, .getAllGroups(username: user))
    }
}
