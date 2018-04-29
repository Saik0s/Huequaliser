//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import AsyncDisplayKit
import RxCocoa
import RxSwift
import UIKit

private var loadingNode: LoadingNode?

public extension UIViewController {
    func startLoadingAnimation() {
        loadingNode?.removeFromSupernode()
        let newLoadingNode = LoadingNode()
        loadingNode = newLoadingNode

        newLoadingNode.frame = UIScreen.main.bounds
        newLoadingNode.layer.opacity = 0
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubnode(newLoadingNode)

        UIView.animate(withDuration: 0.5) { newLoadingNode.layer.opacity = 1 }
    }

    func stopLoadingAnimation() {
        guard let oldLoadingNode = loadingNode else { return }

        loadingNode = nil
        UIView.animate(
                withDuration: 0.5,
                animations: { oldLoadingNode.layer.opacity = 0.0 },
                completion: { _ in
                    oldLoadingNode.removeFromSupernode()
                }
        )
    }
}

public extension Reactive where Base: UIViewController {
    var loadingOverlay: Binder<Bool> {
        return Binder(base) { controller, selected in
            if selected {
                controller.startLoadingAnimation()
            } else {
                controller.stopLoadingAnimation()
            }
        }
    }
}
