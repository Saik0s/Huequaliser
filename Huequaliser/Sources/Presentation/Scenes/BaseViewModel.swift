//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Foundation
import ObjectiveC
import ReactorKit
import RxSwift

public struct NoCallbacks {
}

public protocol ViewModelCallbacksType: class {
    associatedtype Callbacks

    var callback: PublishSubject<Callbacks> { get }
}

// private var callbackKey: String = "callback"
//
// public extension ViewModelCallbacksType {
//     private var _callback: PublishSubject<Callbacks> {
//         if let object = objc_getAssociatedObject(self, &callbackKey) as? PublishSubject<Callbacks> {
//             return object
//         }
//         let object: PublishSubject<Callbacks> = .init()
//         objc_setAssociatedObject(self, &callbackKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//         return object
//     }
//
//     public var callback: PublishSubject<Callbacks> {
//         return _callback
//     }
// }

public protocol ViewModelType: class {
    associatedtype Dependencies

    init(dependencies: Dependencies)
}

public class BaseViewModel<Dependencies>: ViewModelType {
    internal let dependencies: Dependencies

    public required init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

public protocol BaseViewModelType: Reactor, ViewModelCallbacksType {}
