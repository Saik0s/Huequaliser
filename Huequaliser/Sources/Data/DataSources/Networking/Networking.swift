//
// Copyright © 2018 Igor Tarasenko
// Licensed under the MIT license, see LICENSE.md file
//

import Alamofire
import Foundation
import Moya
import OAuth2
import RxMoya
import RxSwift
import UIKit

private class OnlineProvider<Target> where Target: SugarTargetType {
    fileprivate typealias ProviderTarget = MoyaProvider<Target>

    fileprivate let online: Observable<Bool>
    fileprivate let provider: MoyaProvider<Target>

    fileprivate init(
            endpointClosure: @escaping ProviderTarget.EndpointClosure = ProviderTarget.defaultEndpointMapping,
            requestClosure: @escaping ProviderTarget.RequestClosure = ProviderTarget.defaultRequestMapping,
            stubClosure: @escaping ProviderTarget.StubClosure = ProviderTarget.neverStub,
            manager: Manager = SessionManager.default,
            plugins: [PluginType] = [],
            trackInflights: Bool = false,
            online: Observable<Bool> = connectedToInternet()
    ) {
        self.online = online
        provider = MoyaProvider(
                endpointClosure: endpointClosure,
                requestClosure: requestClosure,
                stubClosure: stubClosure,
                manager: manager,
                plugins: plugins,
                trackInflights: trackInflights
        )
    }

    fileprivate func request(_ token: Target) -> Observable<Moya.Response> {
        let actualRequest = provider.rx.request(token)
        return online
                .filter { $0 }
                .take(1) // Take 1 to make sure we only invoke the API once.
                .flatMapLatest { _ in
                    // Turn the online state into a network request
                    actualRequest
                }
    }
}

public protocol NetworkingType {
    func handleRedirect(url: URL) throws
    func request(_ target: SpotifyAPI) -> Observable<String>
}

public struct SpotifySettings {
    public let apiURL: String
    public let authorizeURI: String
    public let tokenURI: String
    public let clientID: String
    public let clientSecret: String
    public let redirectURI: String
    public let scope: String
}

internal final class Networking: NetworkingType {
    // private let bridgeProvider: OnlineProvider<BridgeAPI>
    private let spotifyProvider: OnlineProvider<SpotifyAPI>
    private let spotifySettings: SpotifySettings
    private let spotifyManager: SessionManager = {
        let configuration: URLSessionConfiguration = .default
        var headers: [String: String] = SessionManager.defaultHTTPHeaders
        headers["Accept"] = "application/json"
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 40
        configuration.timeoutIntervalForResource = 40
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        return SessionManager(configuration: configuration)
    }()

    private let loader: OAuth2DataLoader

    func handleRedirect(url: URL) throws {
        try loader.oauth2.handleRedirectURL(url)
    }

    internal func request(_ target: SpotifyAPI) -> Observable<String> {
        loader.oauth2.authConfig.authorizeEmbedded = true
        loader.oauth2.authConfig.authorizeContext = UIApplication.shared.keyWindow?.rootViewController
        return spotifyProvider.request(target).mapString()
    }

    internal init(spotifySettings: SpotifySettings) {
        self.spotifySettings = spotifySettings

        var settings: OAuth2JSON = [:]
        settings["authorize_uri"] = spotifySettings.authorizeURI
        settings["token_uri"] = spotifySettings.tokenURI
        settings["client_id"] = spotifySettings.clientID
        settings["client_secret"] = spotifySettings.clientSecret
        settings["redirect_uris"] = [spotifySettings.redirectURI]
        settings["scope"] = spotifySettings.scope
        let oauth2 = OAuth2CodeGrant(settings: settings)

        let retrier = OAuth2RetryHandler(oauth2: oauth2)
        spotifyManager.adapter = retrier
        spotifyManager.retrier = retrier
        loader = retrier.loader

        let endpointClosure: MoyaProvider<SpotifyAPI>.EndpointClosure = { (target: SpotifyAPI) -> Endpoint in
            let baseURL: URL = URL(string: spotifySettings.apiURL)!

            return Endpoint(
                    url: baseURL.appendingPathComponent(target.path).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
            )
        }

        spotifyProvider = OnlineProvider(
                endpointClosure: endpointClosure,
                manager: spotifyManager,
                plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)]
        )
        // bridgeProvider = OnlineProvider()
    }
}
