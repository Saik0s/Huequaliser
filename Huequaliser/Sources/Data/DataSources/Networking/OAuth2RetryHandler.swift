//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Alamofire
import Foundation
import OAuth2
import UIKit

public class OAuth2RetryHandler: RequestRetrier, RequestAdapter {
    public let loader: OAuth2DataLoader

    public init(oauth2: OAuth2) {
        loader = OAuth2DataLoader(oauth2: oauth2)
        loader.oauth2.logger = OAuth2DebugLogger(.trace)
    }

    /// Intercept 401 and do an OAuth2 authorization.
    public func should(
            _: SessionManager,
            retry request: Request,
            with _: Error,
            completion: @escaping RequestRetryCompletion
    ) {
        if let response = request.task?.response as? HTTPURLResponse,
           401 == response.statusCode,
           let req = request.request {
            var dataRequest = OAuth2DataRequest(request: req, callback: { _ in })
            dataRequest.context = completion
            loader.enqueue(request: dataRequest)
            loader.attemptToAuthorize { authParams, _ in
                self.loader.dequeueAndApply { req in
                    if let comp = req.context as? RequestRetryCompletion {
                        comp(nil != authParams, 0.0)
                    }
                }
            }
        } else {
            completion(false, 0.0) // not a 401, not our problem
        }
    }

    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard loader.oauth2.accessToken != nil else {
            return urlRequest
        }
        return try urlRequest.signed(with: loader.oauth2) // "try" added in 3.0.2
    }
}
