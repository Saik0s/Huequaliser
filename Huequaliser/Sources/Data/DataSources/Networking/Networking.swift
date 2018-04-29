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
            baseURLClosure: @escaping (Target) -> URL = { $0.baseURL },
            requestClosure: @escaping ProviderTarget.RequestClosure = ProviderTarget.defaultRequestMapping,
            stubClosure: @escaping ProviderTarget.StubClosure = ProviderTarget.neverStub,
            manager: Manager = SessionManager.default,
            plugins: [PluginType] = [],
            trackInflights: Bool = false,
            online: Observable<Bool> = connectedToInternet()
    ) {
        self.online = online
        let endpointClosure: MoyaProvider<Target>.EndpointClosure = { (target: Target) -> Endpoint in
            Endpoint(
                    url: baseURLClosure(target).appendingPathComponent(target.path).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
            )
        }
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

public protocol HueNetworkingType: class {
    func hueMappingRequest<T: Codable>(
            _ type: T.Type,
            _ token: HueAPI,
            atKeyPath keyPath: String?,
            using decoder: JSONDecoder,
            failsOnEmptyData: Bool
    ) -> Observable<T>
}

public extension HueNetworkingType {
    func hueMappingRequest<T: Codable>(
            _: T.Type,
            _ token: HueAPI,
            atKeyPath keyPath: String? = nil,
            using decoder: JSONDecoder = JSONDecoder(),
            failsOnEmptyData: Bool = true
    ) -> Observable<T> {
        return hueMappingRequest(
                T.self,
                token,
                atKeyPath: keyPath,
                using: decoder,
                failsOnEmptyData: failsOnEmptyData
        )
    }
}

public protocol SpotifyNetworkingType: class {
    func spotifyMappingRequest<T: Codable>(
            _ type: T.Type,
            _ token: SpotifyAPI,
            atKeyPath keyPath: String?,
            using decoder: JSONDecoder,
            failsOnEmptyData: Bool
    ) -> Observable<T>
}

public extension SpotifyNetworkingType {
    func spotifyMappingRequest<T: Codable>(
            _: T.Type,
            _ token: SpotifyAPI,
            atKeyPath keyPath: String? = nil,
            using decoder: JSONDecoder = JSONDecoder(),
            failsOnEmptyData: Bool = true
    ) -> Observable<T> {
        return spotifyMappingRequest(
                T.self,
                token,
                atKeyPath: keyPath,
                using: decoder,
                failsOnEmptyData: failsOnEmptyData
        )
    }
}

public protocol NetworkingType: HueNetworkingType, SpotifyNetworkingType {
    func handleRedirect(url: URL) throws
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
    private let hueProvider: OnlineProvider<HueAPI>

    private let spotifyProvider: OnlineProvider<SpotifyAPI>
    private let spotifySettings: SpotifySettings
    private let loader: OAuth2DataLoader
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

    func handleRedirect(url: URL) throws {
        try loader.oauth2.handleRedirectURL(url)
    }

    public func hueMappingRequest<T: Codable>(
            _ type: T.Type,
            _ token: HueAPI,
            atKeyPath keyPath: String? = nil,
            using decoder: JSONDecoder = JSONDecoder(),
            failsOnEmptyData: Bool = true
    ) -> Observable<T> {
        return hueProvider.request(token).map(
                type,
                atKeyPath: keyPath,
                using: decoder,
                failsOnEmptyData: failsOnEmptyData
        ).do(onError: { dlog($0) })
    }

    public func spotifyMappingRequest<T: Codable>(
            _ type: T.Type,
            _ token: SpotifyAPI,
            atKeyPath keyPath: String? = nil,
            using decoder: JSONDecoder = JSONDecoder(),
            failsOnEmptyData: Bool = true
    ) -> Observable<T> {
        loader.oauth2.authConfig.authorizeEmbedded = true
        loader.oauth2.authConfig.authorizeContext = UIApplication.shared.keyWindow?.rootViewController
        return spotifyProvider.request(token).map(
                type,
                atKeyPath: keyPath,
                using: decoder,
                failsOnEmptyData: failsOnEmptyData
        )
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

        spotifyProvider = OnlineProvider(
                baseURLClosure: { _ in URL(string: spotifySettings.apiURL).require() },
                manager: spotifyManager,
                plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)]
        )

        hueProvider = OnlineProvider(
                baseURLClosure: { target in
                    if case HueAPI.getBridgesFromNUPnP = target {
                        return URL(string: Constants.Hue.meethueURI).require()
                    }

                    let host: String = AppEnvironment.current.hueBridge?.ipAddress ?? "127.0.0.1"
                    return URL(string: "http://\(host)").require()
                },
                plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)]
        )
    }
}
