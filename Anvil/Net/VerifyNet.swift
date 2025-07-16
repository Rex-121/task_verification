//
//  VerifyNet.swift
//  verification
//
//  Created by Tyrant on 2025/7/16.
//

import Foundation
import Moya

enum VerifyNet {
    
    /// 三要素
    case three(_ data: ThreeVerifyData)
    
//    case login(_ data: LoginBaseData)
    
}

extension VerifyNet: VerificationBaseNet {
    var path: String {
        return "/gw/identity/3"
    }
    
    var method: Moya.Method {
        switch self {
        case .three:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .three(let data):
            return .requestParameters(parameters: data.dic,
                                      encoding: URLEncoding())
        }
    }
    
    
    
}

class ThreeVerifyData: Encodable {
    
    var userId: String = ""
    var name: String = ""
    var idCard: String = ""
    var mobile: String = ""
    
    var dic: [String: String] {
        
        do {
            let value = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: .fragmentsAllowed)
            print(value)
            return value as! [String: String]
        } catch {
            
        }
        return [:]
    }
    
}



/**
 三要素查询
 /gw/identity/3  GET请求
 参数
     1. userId -> 用户id
     2. name -> 用户姓名
     3. idCard -> 用户身份证号
     4. mobile -> 用户手机号
 */
