//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

public extension Optional {
    /// Executes the closure if the optional has a value
    @discardableResult
    func `do`(onSome: ((Wrapped) -> Void)? = nil, onNone: (() -> Void)? = nil) -> Wrapped? {
        if case let .some(value) = self { onSome?(value) } else { onNone?() }
        return self
    }
}

public extension Optional {
    /**
     *  Require this optional to contain a non-nil value
     *
     *  This method will either return the value that this optional contains, or trigger
     *  a `preconditionFailure` with an error message containing debug information.
     *
     *  - parameter hint: Optionally pass a hint that will get included in any error
     *                    message generated in case nil was found.
     *
     *  - return: The value this optional contains.
     */
    func require(hint hintExpression: @autoclosure () -> String? = nil,
                 file: StaticString = #file,
                 line: UInt = #line) -> Wrapped {
        guard let unwrapped = self else {
            var message: String = "Required value was nil in \(file), at line \(line)"

            if let hint: String = hintExpression() {
                message.append(". Debugging hint: \(hint)")
            }

            preconditionFailure(message)
        }

        return unwrapped
    }
}

extension Optional: Hashable where Wrapped: Hashable {
    public var hashValue: Int {
        if case let Optional.some(value) = self { return value.hashValue }
        return 0
    }
}

public protocol OptionalProtocol {
    func isSome() -> Bool
    func unwrap() -> Any
}

extension Optional: OptionalProtocol {
    public func isSome() -> Bool {
        switch self {
            case .none: return false
            case .some: return true
        }
    }

    public func unwrap() -> Any {
        switch self {
            case .none: preconditionFailure("nill unwrap")
            case let .some(unwrapped): return unwrapped
        }
    }
}
