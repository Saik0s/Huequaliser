//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import AsyncDisplayKit
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

public final class StatusViewController: ASViewController<StatusNode>, View {

    // MARK: Binding

    public func bind(reactor: StatusViewModel) {
        node.rx.currentTrackTap
                .map { Reactor.Action.getCurrentlyPlaying }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

        node.rx.bridgeSearchTap
                .map { Reactor.Action.searchForBridges }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

        reactor.state
                .map { $0.currentTrack }
                .subscribe(onNext: { dlog($0) })
                .disposed(by: disposeBag)

        reactor.state
                .map { $0.bridges }
                .distinctUntilChanged()
                .subscribe(onNext: { dlog($0) })
                .disposed(by: disposeBag)
    }
}
