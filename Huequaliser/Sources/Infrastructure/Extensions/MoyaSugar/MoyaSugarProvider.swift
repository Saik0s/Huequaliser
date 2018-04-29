import class Foundation.DispatchQueue
import Moya

/// `MoyaSugarProvider` overrides `parameterEncoding` and `httpHeaderFields` of the
/// `endpointClosure` with `SugarTargetType`. `MoyaSugarProvider` can be used only with
/// `SugarTargetType`.
open class MoyaSugarProvider<Target: SugarTargetType>: MoyaProvider<Target> {
    public override init(
            endpointClosure: @escaping EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
            requestClosure: @escaping RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
            stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
            callbackQueue: DispatchQueue? = nil,
            manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
            plugins: [PluginType] = [],
            trackInflights: Bool = false
    ) {
        let sugarEndpointClosure: MoyaProvider<Target>.EndpointClosure = { (target: Target) -> Endpoint in
            let endpoint = endpointClosure(target)

            return Endpoint(
                    url: target.url.absoluteString,
                    sampleResponseClosure: endpoint.sampleResponseClosure,
                    method: endpoint.method,
                    task: endpoint.task,
                    httpHeaderFields: endpoint.httpHeaderFields
            )
        }
        super.init(
                endpointClosure: sugarEndpointClosure,
                requestClosure: requestClosure,
                stubClosure: stubClosure,
                callbackQueue: callbackQueue,
                manager: manager,
                plugins: plugins,
                trackInflights: trackInflights
        )
    }
}
