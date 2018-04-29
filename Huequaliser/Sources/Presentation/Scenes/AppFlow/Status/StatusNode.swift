//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

public final class StatusNode: ASDisplayNode {
    // public var buttonPressed: Driver<Void> { return button.rx.tap.asDriver() }

    fileprivate let button: ASButtonNode = ASButtonNode()

    public override init() {
        super.init()

        backgroundColor = .white
        button.setTitle("Chec", with: .preferredFont(forTextStyle: .body), with: .blue, for: .normal)

        automaticallyManagesSubnodes = true
    }

    public override func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
        button.style.height = ASDimensionMake("10%")
        button.style.width = ASDimensionMake("20%")

        let centerSpec: ASCenterLayoutSpec = .init(
                centeringOptions: .XY,
                sizingOptions: [],
                child: button
        )
        return centerSpec
    }
}

public extension Reactive where Base: StatusNode {
    var buttonPress: ControlEvent<Void> { return base.button.rx.tap }
}
