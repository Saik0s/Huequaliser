//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Reachability
import RxSwift

private let reachabilityManager = ReachabilityManager()

public func connectedToInternet() -> Observable<Bool> {
    return reachabilityManager?.reach ?? Observable.just(true)
}

private class ReachabilityManager {
    private let reachability: Reachability
    private let _reach: ReplaySubject<Bool> = .create(bufferSize: 1)

    var reach: Observable<Bool> {
        return _reach.asObservable()
    }

    init?() {
        guard let reachability: Reachability = Reachability() else {
            return nil
        }
        self.reachability = reachability

        do {
            try self.reachability.startNotifier()
        } catch {
            return nil
        }

        _reach.onNext(self.reachability.connection != .none)

        self.reachability.whenReachable = { _ in
            DispatchQueue.main.async { self._reach.onNext(true) }
        }

        self.reachability.whenUnreachable = { _ in
            DispatchQueue.main.async { self._reach.onNext(false) }
        }
    }

    deinit {
        reachability.stopNotifier()
    }
}
