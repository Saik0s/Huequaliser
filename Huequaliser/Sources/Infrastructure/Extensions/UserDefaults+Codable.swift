//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Foundation

/// Helper methods to store and retrieve codable types
public extension UserDefaults {
    func store<T: Codable>(_ value: T, forKey key: String, encoder: JSONEncoder = JSONEncoder()) {
        do {
            let data: Data = try encoder.encode(value)
            dlog("Successfully encoder data for key", key)
            set(data, forKey: key)
        } catch {
            dlog(error.localizedDescription)
        }
    }

    func fetch<T: Codable>(forKey key: String, type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> T? {
        var result: T?
        if let data = data(forKey: key) {
            do {
                result = try decoder.decode(type, from: data) as T
                dlog("Successfully decode data for key", key)
            } catch {
                dlog(error.localizedDescription)
            }
        } else {
            dlog("No data for key", key)
        }

        return result
    }
}
