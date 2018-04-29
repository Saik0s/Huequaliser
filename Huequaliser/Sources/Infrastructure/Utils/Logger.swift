//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Foundation

private enum Logger {
    private enum Color: String {
        case red = "\u{001B}[0;31m"
        case green = "\u{001B}[0;32m"
        case yellow = "\u{001B}[0;33m"
        case blue = "\u{001B}[0;34m"
        case magenta = "\u{001B}[0;35m"
        case cyan = "\u{001B}[0;36m"
        case white = "\u{001B}[0;37m"
        case reset = "\u{001B}[0;0m"
        case none = ""
    }

    internal enum Level {
        case warning
        case verbose
        case info
        case error
        case debug
    }

    private static let separator: String = " "
    private static var isColorful: Bool = true

    private static func formatMessage(
            _ items: [Any?],
            level: Level,
            _ file: StaticString,
            _ function: StaticString,
            _ line: UInt
    ) -> String {
        var logLevel: String
        var logColor: Color = .none
        let output: String = items.map { String(describing: $0 ?? "nil") }.joined(separator: separator)

        switch level {
            case .error:
                logLevel = "E"
                logColor = isColorful ? .red : .none
            case .warning:
                logLevel = "W"
                logColor = isColorful ? .yellow : .none
            case .info:
                logLevel = "I"
                logColor = isColorful ? .white : .none
            case .debug:
                logLevel = "D"
                logColor = isColorful ? .green : .none
            default:
                logLevel = "V"
                logColor = isColorful ? .cyan : .none
        }

        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        let date: Date = Date()
        let dateString: String = dateFormatter.string(from: date)

        var string: String = ""
        string.append(logColor.rawValue)
        string.append(logLevel)
        string.append(" ")
        string.append(dateString)
        string.append(" ")
        string.append(URL(fileURLWithPath: "\(file)").lastPathComponent)
        string.append(":")
        string.append("\(line)")
        string.append(" ")
        string.append("\(function)")
        string.append(" | ")
        string.append(output)
        string.append(isColorful ? Color.reset.rawValue : "")

        return string
    }

    fileprivate static func print(
            _ items: [Any?],
            level: Level,
            file: StaticString,
            function: StaticString,
            line: UInt
    ) {
        let string: String = Logger.formatMessage(items, level: level, file, function, line)
        Swift.print(string)
    }
}

public enum Log {
    public static func warn(
            _ items: Any?...,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
    ) {
        Logger.print(items, level: .warning, file: file, function: function, line: line)
    }

    public static func verbose(
            _ items: Any?...,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
    ) {
        Logger.print(items, level: .verbose, file: file, function: function, line: line)
    }

    public static func info(
            _ items: Any?...,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
    ) {
        Logger.print(items, level: .info, file: file, function: function, line: line)
    }

    public static func error(
            _ items: Any?...,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
    ) {
        Logger.print(items, level: .error, file: file, function: function, line: line)
    }

    public static func debug(
            _ items: Any?...,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
    ) {
        Logger.print(items, level: .debug, file: file, function: function, line: line)
    }
}

public func dlog(
        _ items: Any?...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
) {
    Logger.print(items, level: .debug, file: file, function: function, line: line)
}
