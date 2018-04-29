import RxCocoa
import RxSwift

public extension ObservableConvertibleType where E == Void {
    func asDriver() -> Driver<E> {
        return asDriver(onErrorJustReturn: Void())
    }
}
