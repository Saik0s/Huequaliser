import struct Foundation.URL
import Moya

public protocol SugarTargetType: TargetType {
    var url: URL { get }

    /// Returns `Route` which contains HTTP method and URL path information.
    ///
    /// Example:
    ///
    /// ```
    /// var route: Route {
    ///   return .get("/me")
    /// }
    /// ```
    var route: Route { get }
    var parameters: Parameters? { get }
}

public extension SugarTargetType {
    var url: URL {
        return self.defaultURL
    }

    var defaultURL: URL {
        return self.path.isEmpty ? self.baseURL : self.baseURL.appendingPathComponent(self.path)
    }

    var path: String {
        return self.route.path
    }

    var method: Moya.Method {
        return self.route.method
    }

    var task: Task {
        guard let parameters = self.parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters.values, encoding: parameters.encoding)
    }

    var baseURL: URL { fatalError("baseURL has not been implemented") }

    var sampleData: Data { fatalError("sampleData has not been implemented") }

    var headers: [String: String]? { return nil }

    var validationType: ValidationType { return .successCodes }
}
