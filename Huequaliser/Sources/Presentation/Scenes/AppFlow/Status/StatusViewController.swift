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
        node.rx.buttonPress
                .map { Reactor.Action.getCurrentTrack }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)

        reactor.state
                .map { $0.currentTrack }
                .bind(onNext: { print($0) })
                .disposed(by: disposeBag)
    }
}
