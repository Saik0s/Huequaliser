//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Foundation

public protocol MirrorStringConvertible {
}

public extension CustomStringConvertible where Self: MirrorStringConvertible {
    var description: String {
        return deepDescription(any: self)
    }
}

private typealias UnwrappedChild = (label: String, value: Any)

// swiftlint:disable cyclomatic_complexity function_body_length
private func deepDescription(any: Any) -> String {
    guard let any = deepUnwrap(any: any) else {
        return "nil"
    }

    if any is Void {
        return "Void"
    }

    if let int = any as? Int {
        return String(int)
    } else if let double = any as? Double {
        return String(double)
    } else if let float = any as? Float {
        return String(float)
    } else if let bool = any as? Bool {
        return String(bool)
    } else if let string = any as? String {
        return "\"\(string)\""
    }

    let indentedString: (String) -> String = {
        $0.components(separatedBy: .newlines)
                .map { $0.isEmpty ? "" : "\n    \($0)" }
                .joined()
    }

    let mirror = Mirror(reflecting: any)

    let properties: [UnwrappedChild] = mirror.children.map { ($0.label ?? "", $0.value) }

    guard let displayStyle = mirror.displayStyle else {
        return String(describing: any)
    }

    switch displayStyle {
        case .tuple:
            if properties.isEmpty { return "()" }

            var string = "("

            for (index, property) in properties.enumerated() {
                if property.label.first.or(Character("")) == "." {
                    string += deepDescription(any: property.value)
                } else {
                    string += "\(property.label): \(deepDescription(any: property.value))"
                }

                string += (index < properties.count - 1 ? ", " : "")
            }

            return string + ")"
        case .collection, .set:
            if properties.isEmpty { return "[]" }

            var string = "["

            for (index, property) in properties.enumerated() {
                string += indentedString(
                        deepDescription(any: property.value) + (index < properties.count - 1 ? ",\n" : "")
                )
            }

            return string + "\n]"
        case .dictionary:
            if properties.isEmpty { return "[:]" }

            var string = "["

            for (index, property) in properties.enumerated() {
                let pair = Array(Mirror(reflecting: property.value).children)

                string += indentedString(
                        "\(deepDescription(any: pair[0].value)): \(deepDescription(any: pair[1].value))" + (
                                index < properties.count - 1 ? ",\n" : ""
                        )
                )
            }

            return string + "\n]"
        case .enum:
            if let any = any as? CustomDebugStringConvertible {
                return any.debugDescription
            }

            if properties.isEmpty { return "\(mirror.subjectType)." + String(describing: any) }

            var string = "\(mirror.subjectType).\(properties.first?.label ?? "")"

            let associatedValueString = deepDescription(any: properties.first.require().value)

            if associatedValueString.first.or(Character("")) == "(" {
                string += associatedValueString
            } else {
                string += "(\(associatedValueString))"
            }

            return string
        case .struct, .class:
            if let any = any as? CustomDebugStringConvertible {
                return any.debugDescription
            }

            if properties.isEmpty { return String(describing: any) }

            var string = "<\(mirror.subjectType)"

            if displayStyle == .class, let object = any as? AnyClass {
                string += ": \(Unmanaged<AnyObject>.passUnretained(object).toOpaque())"
            }

            string += "> {"

            for (index, property) in properties.enumerated() {
                string += indentedString(
                        "\(property.label): \(deepDescription(any: property.value))" + (
                                index < properties.count - 1 ? ",\n" : ""
                        )
                )
            }

            return string + "\n}"
        case .optional: fatalError("deepUnwrap must have failed...")
    }
}

private func deepUnwrap(any: Any) -> Any? {
    if let opt = any as? OptionalProtocol {
        return opt.isSome() ? Optional.some(opt.unwrap()) : nil
    } else {
        return any
    }
}
