//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

public final class StatusNode: ASDisplayNode {
    // public var buttonPressed: Driver<Void> { return button.rx.tap.asDriver() }

    fileprivate let currentTrackButton: ASButtonNode = ASButtonNode()
    fileprivate let bridgeSearchButton: ASButtonNode = ASButtonNode()

    public override init() {
        super.init()

        [(currentTrackButton, "Get Current Track"), (bridgeSearchButton, "Search for available bridges")].forEach {
            $0.0.setTitle(
                    $0.1,
                    with: .preferredFont(forTextStyle: .headline),
                    with: .blue,
                    for: .normal
            )
            $0.0.backgroundColor = .green
            $0.0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        }

        backgroundColor = .white

        automaticallyManagesSubnodes = true
    }

    public override func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
        let stack: ASStackLayoutSpec = .vertical()
        stack.children = [currentTrackButton, bridgeSearchButton]
        stack.spacing = 30.0

        let centerSpec: ASCenterLayoutSpec = .init(
                centeringOptions: .XY,
                sizingOptions: [],
                child: stack
        )
        return centerSpec
    }
}

public extension Reactive where Base: StatusNode {
    var currentTrackTap: ControlEvent<Void> { return base.currentTrackButton.rx.tap }
    var bridgeSearchTap: ControlEvent<Void> { return base.bridgeSearchButton.rx.tap }
}
