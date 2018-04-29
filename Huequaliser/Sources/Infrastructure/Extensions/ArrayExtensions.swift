//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

extension Array: Hashable where Element: Hashable {
    public var hashValue: Int {
        return map { $0.hashValue }.reduce(0) { $0 + $1 }
    }
}
