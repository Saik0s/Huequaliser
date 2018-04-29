//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Foundation
import RxCocoa
import RxSwift
import Socket

public protocol HueServiceType {
    func searchForBridges() -> Observable<[HueBridge]>
}

public protocol HueServiceContainer {
    var hueService: HueServiceType { get }
}

public final class HueService: HueServiceType {
    private var nupnpRequest: URLRequest {
        let url: URL = URL(string: "https://www.meethue.com/api/nupnp").require()

        return URLRequest(url: url)
    }

    public init() {}

    public func searchForBridges() -> Observable<[HueBridge]> {
        return URLSession.shared.rx.decodable(request: nupnpRequest, [HueBridge].self)
    }
}

private extension Reactive where Base: URLSession {
    func decodable<T: Decodable>(
            request: URLRequest,
            _ type: T.Type,
            decoder: JSONDecoder = JSONDecoder()
    ) -> Observable<T> {
        return data(request: request).map { try decoder.decode(type, from: $0) }
    }
}
