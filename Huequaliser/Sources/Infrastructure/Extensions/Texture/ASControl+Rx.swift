//
// Created by Igor Tarasenko on 05/04/18.
// Copyright © 2018 24coms. All rights reserved.
//

import AsyncDisplayKit
import Foundation
import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: ASControlNode {
    var isEnabled: Binder<Bool> {
        return Binder(base) { control, value in
            control.isEnabled = value
        }
    }

    var isSelected: Binder<Bool> {
        return Binder(base) { control, selected in
            control.isSelected = selected
        }
    }

    var isHidden: Binder<Bool> {
        return Binder(base) { control, hidden in
            control.isHidden = hidden
        }
    }

    func controlASEvent(_ controlEvents: ASControlNodeEvent) -> RxCocoa.ControlEvent<Swift.Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in
            MainScheduler.ensureExecutingOnScheduler()

            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            let controlTarget = ASControlTarget(
                control: control,
                controlEvents: controlEvents
            ) { _ in
                observer.on(.next(()))
            }

            return Disposables.create(with: controlTarget.dispose)
        }.takeUntil(deallocated)

        return ControlEvent(events: source)
    }

    func controlProperty<T>(
        editingEvents: ASControlNodeEvent,
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> Void
    ) -> ControlProperty<T> {
        let source: Observable<T> = Observable.create { [weak weakControl = base] observer in
            guard let control = weakControl else {
                observer.on(.completed)
                return Disposables.create()
            }

            observer.on(.next(getter(control)))

            let controlTarget = ASControlTarget(
                control: control,
                controlEvents: editingEvents
            ) { _ in
                if let control = weakControl {
                    observer.on(.next(getter(control)))
                }
            }

            return Disposables.create(with: controlTarget.dispose)
        }.takeUntil(deallocated)

        let bindingObserver = Binder(base, binding: setter)

        return ControlProperty<T>(values: source, valueSink: bindingObserver)
    }

    internal func controlPropertyWithDefaultEvents<T>(
        editingEvents _: ASControlNodeEvent = [.valueChanged],
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> Void
    ) -> ControlProperty<T> {
        return controlProperty(
            editingEvents: [.valueChanged],
            getter: getter,
            setter: setter
        )
    }
}
