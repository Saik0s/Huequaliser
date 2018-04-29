//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import RxCocoa
import RxOptional
import RxSwift

/// Holds stack of global app states
public final class AppEnvironment {
    private static let storeKey: String = "com.appEnvironment"
    private static let _environmentVariable: Variable<Environment> = .init(Environment())
    private static let environmentSubject: PublishSubject<Environment> = {
        let subject: PublishSubject<Environment> = .init()
        var sub = subject.do(onNext: { env in
            var tracker: RxErrorTracker = env.errorTracker
            withUnsafePointer(to: &tracker) { (address: UnsafePointer<RxErrorTracker>) -> Void in
                dlog("errorTracker has address: \(address)")
                return
            }
        })
        sub.bind(to: _environmentVariable)
        return subject
    }()

    private static func newValue(_ env: Environment) {
        environmentSubject.onNext(env)
    }

    // private static let bag: DisposeBag = DisposeBag()

    public static var current: Environment {
        return _environmentVariable.value
    }

    public static var asDriver: Driver<Environment> {
        return _environmentVariable.asDriver()
    }

    public static func pushEnvironment(_ env: Environment) {
        dlog(env)
        saveEnvironment(environment: env)
        newValue(env)
    }

    public static func updateCurrentEnvironment(
            dependencies: DependencyContainer? = current.dependencies,
            sceneFactory: SceneFactoryType? = current.sceneFactory,
            hueBridge: HueBridge? = current.hueBridge,
            hueUser: HueUser? = current.hueUser
    ) {
        pushEnvironment(
                Environment(
                        dependencies: dependencies,
                        sceneFactory: sceneFactory,
                        activityIndicator: current.activityIndicator,
                        errorTracker: current.errorTracker,
                        hueBridge: hueBridge,
                        hueUser: hueUser
                )
        )
    }

    public static func restoreFromStorage() {
        if let stored = UserDefaults.standard.fetch(forKey: storeKey, type: Environment.self) {
            updateCurrentEnvironment(hueBridge: stored.hueBridge, hueUser: stored.hueUser)
        }
    }

    internal static func saveEnvironment(environment _: Environment = AppEnvironment.current) {
        UserDefaults.standard.store(current, forKey: storeKey)
    }
}
