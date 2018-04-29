//
// Created by Igor Tarasenko on 05/04/18.
// Copyright © 2018 24coms. All rights reserved.
//

import AsyncDisplayKit
import Foundation
import RxCocoa
import RxSwift
import UIKit

public final class ASControlTarget: _RXKVOObserver, Disposable {
    public typealias Control = AsyncDisplayKit.ASControlNode
    public typealias ControlEvents = AsyncDisplayKit.ASControlNodeEvent
    public typealias Callback = (Control) -> Void

    private let selector: Selector = #selector(ASControlTarget.eventHandler(_:))

    private weak var control: Control?
    private let controlEvents: ControlEvents
    private var callback: Callback?

    public init(
        control: Control,
        controlEvents: ControlEvents,
        callback: @escaping Callback
    ) {
        MainScheduler.ensureExecutingOnScheduler()

        self.control = control
        self.controlEvents = controlEvents
        self.callback = callback

        super.init()

        control.addTarget(
            self,
            action: selector,
            forControlEvents: controlEvents
        )

        guard method(for: selector) != nil else {
            fatalError("Can't find method")
        }
    }

    @objc public func eventHandler(_: Control) {
        if let callback = self.callback, let control = self.control {
            callback(control)
        }
    }

    public override func dispose() {
        super.dispose()

        control?.removeTarget(
            self,
            action: selector,
            forControlEvents: controlEvents
        )
        callback = nil
    }
}
