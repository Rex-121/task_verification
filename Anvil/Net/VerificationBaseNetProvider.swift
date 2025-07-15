//
//  InterviewNetProvider.swift
//  boss_interview_demo
//
//  Created by Tyrant on 2025/6/20.
//

import Foundation
import Moya

open class VerificationBaseNetProvider<T: AnvilTargetType>: NetProvider<T> {
    

        
    public override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider<T>.defaultEndpointMapping,
                         requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                         stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider<T>.neverStub,
                         callbackQueue: DispatchQueue? = nil,
                         session: Session = RooboDefaultSession.defaultSession(),
                         plugins: [PluginType] = [],
                         trackInflights: Bool = false) {
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: [], trackInflights: trackInflights)
        
        
    }
    
    
}


public protocol SoloSessionProvider {
    ///默认session
    static func defaultSession() -> Session
    ///默认请求头
    static var defaultHTTPHeader: HTTPHeaders { get }
    ///默认安全策略
    static func defaultPolicy() -> ServerTrustPolice?
    
}

public extension SoloSessionProvider {
    
    
    static func defaultSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = Self.defaultHTTPHeader.dictionary
        return Moya.Session(configuration: configuration, delegate: SessionDelegate(), serverTrustManager: Self.defaultPolicy())
    }
    
    
    static var defaultHTTPHeader: HTTPHeaders {
        
        // Accept-Encoding HTTP Header; see https://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"

        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")

        // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
        // Example: `iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0`
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
                let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                let osNameVersion: String = {
                    let version = ProcessInfo.processInfo.operatingSystemVersion
                    let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                    let osName: String = {
                        #if os(iOS)
                            return "iOS"
                        #elseif os(watchOS)
                            return "watchOS"
                        #elseif os(tvOS)
                            return "tvOS"
                        #elseif os(macOS)
                            return "OS X"
                        #elseif os(Linux)
                            return "Linux"
                        #else
                            return "Unknown"
                        #endif
                    }()

                    return "\(osName) \(versionString)"
                }()

                return "\(executable)/\(appVersion) (build:\(appBuild); \(osNameVersion))"
            }

            return "Anvil"
        }()

        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }
    
    
    static func defaultPolicy() -> ServerTrustPolice? { return nil }
    
    
    
}


public struct RooboDefaultSession: AnvilSessionProvider { }

//struct Log: PluginType {
//
//    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
//        switch result {
//        case .success(let r):
//            r.response?.headers
//
//            return result
//        case .failure:
//            return result
//        }
//    }
//
//    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        switch result {
//        case .failure: break
//        case .success(let response):break
//
//        }
//    }
//}



//import PKHUD
//
//struct NeedLoginPlugin: PluginType {
//
////    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
////        switch result {
////        case .success(let r):
////
////            guard let value = try? JSONDecoder().decode(K.self, from: r.data) else { return result }
////
////
////
////            return result
////        case .failure:
////            return result
////        }
////    }
//
//    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        switch result {
//        case .failure: break
//        case .success(let response):break
////            guard let value = try? JSONDecoder().decode(K.self, from: response.data) else { return }
////
////            if (value.result == -401) {
////
////                HUD.flash(.label("请先登录"))
////
////                User.now.sign(.off)
////
////                let view = AlertViews.view(title: "您的账号已在别的设备登录", confirm: "知道了") {
////
////                }
////
////                view.hideCancel()
////
////                OverWindows.shared.add(view: view) { [weak view] in
////                    view?.snp.makeConstraints { $0.edges.equalToSuperview() }
////                }
////
////            }
//
//        }
//    }
//
//    struct K: Decodable {
//        let result: Int
//    }
//}
