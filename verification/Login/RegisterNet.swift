//
//  AuthNet.swift
//  boss_interview_demo
//
//  Created by Tyrant on 2025/6/20.
//
import Foundation

import Moya

enum RegisterNet {
    
    /// 注册
    case register(_ data: Encodable)
    
    case login(_ data: LoginBaseData)
    
}

extension RegisterNet: VerificationBaseNet {
        
    var path: String {
        switch self {
        case .register: return "/gw/user-app"
        case .login: return "/gw/user-app"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register: return .post
        case .login: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        
        case .register(let data):
            return .requestJSONEncodable(data)
        case .login(let data):
            return .requestParameters(parameters: ["userPhone": data.userPhone, "userPwd": data.userPwd], encoding: URLEncoding())
        }
    }
    
}

