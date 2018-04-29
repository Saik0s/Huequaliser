//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import ReactorKit
import RxCocoa
import RxOptional
import RxSwift
import UIKit

public final class AppFlowController: UIViewController, View {
    private var currentChild: UIViewController? {
        willSet {
            guard let newVC = newValue else {
                currentChild.do(onSome: remove(childController:))
                return
            }

            guard let previousVC = currentChild else {
                add(childController: newVC)
                return
            }

            previousVC.willMove(toParentViewController: nil)
            addChildViewController(newVC)
            newVC.view.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height)
            transition(from: previousVC, to: newVC, duration: 0.25, options: .curveEaseIn, animations: {
                newVC.view.translatesAutoresizingMaskIntoConstraints = false
                newVC.view.transform = .identity
            }, completion: { _ in
                previousVC.removeFromParentViewController()
                newVC.didMove(toParentViewController: self)
            })
        }
    }

    // MARK: Binding

    public func bind(reactor _: AppFlowViewModel) {
        rx.viewDidLoad.withLatestFrom(AppEnvironment.asDriver)
                .map { $0.sceneFactory }
                .filterNil()
                .bind(onNext: { factory in
                    factory.make(.status) { [weak self] viewController in
                        self?.currentChild = viewController
                    }
                }).disposed(by: disposeBag)

        AppEnvironment.current.activityIndicator.drive(rx.loadingOverlay).disposed(by: disposeBag)
        AppEnvironment.current.errorTracker.filterNil().drive(onNext: { error in
            Log.error(error)
            let alert = UIAlertController(title: "Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "OK",
                                       style: UIAlertActionStyle.cancel,
                                       handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
