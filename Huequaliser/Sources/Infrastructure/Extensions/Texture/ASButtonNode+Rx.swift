//
// Created by Igor Tarasenko on 05/04/18.
// Copyright © 2018 24coms. All rights reserved.
//

import AsyncDisplayKit
import Foundation
import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: ASButtonNode {
    var tap: ControlEvent<Void> {
        return controlASEvent(ASControlNodeEvent.touchUpInside)
    }

    func image(for controlState: UIControlState = []) -> Binder<UIImage?> {
        return Binder(base) { (button: ASButtonNode, image: UIImage?) -> Void in
            button.setImage(image, for: controlState)
        }
    }

    func backgroundImage(for controlState: UIControlState = []) -> Binder<UIImage?> {
        return Binder(base) { (button: ASButtonNode, image: UIImage?) -> Void in
            button.setBackgroundImage(image, for: controlState)
        }
    }

    func attributedTitle(for controlState: UIControlState = []) -> Binder<NSAttributedString?> {
        return Binder(base) { (button: ASButtonNode, attributedTitle: NSAttributedString?) -> Void in
            button.setAttributedTitle(attributedTitle, for: controlState)
        }
    }
}
