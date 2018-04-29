//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

#if DEBUG
public protocol Value: Hashable, Codable, Then, MirrorStringConvertible, CustomStringConvertible {}
#else
public protocol Value: Hashable, Codable, Then {}
#endif

public protocol AutoEquatable {
}

public protocol AutoInterface {
}

public protocol AutoDescription {
}

public protocol AutoPropertiesProtocol {
}

public protocol AutoInitable {
}

public protocol AutoDecodable: Decodable {}
public protocol AutoEncodable: Encodable {}
public protocol AutoCodable: AutoDecodable, AutoEncodable, Then {}
