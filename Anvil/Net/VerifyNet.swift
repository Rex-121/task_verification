//
//  VerifyNet.swift
//  verification
//
//  Created by Tyrant on 2025/7/16.
//

import Foundation
import Moya
import UIKit

enum VerifyNet {
    
    /// 三要素
    case three(_ data: ThreeVerifyData)
    
    
    case uploadIdCard(IDCardVerifyViewController.IDType, UIImage)
    //    case login(_ data: LoginBaseData)
    
    case uploadContacts(_ contacts: ContactUpload)
}

extension VerifyNet: VerificationBaseNet {
    var path: String {
        
        switch self {
        case .three:
            return "/gw/identity/3"
        case .uploadIdCard:
            return "/gw/upload/card"
        case .uploadContacts:
            return "/gw/app-book"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .three:
            return .get
        case .uploadIdCard, .uploadContacts: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .three(let data):
            return .requestParameters(parameters: data.dic,
                                      encoding: URLEncoding())
        case let .uploadContacts(data):
            return .requestJSONEncodable(data)
        case let .uploadIdCard(type, image):
            
            var formData = [MultipartFormData]()
            
            guard let imageData = image.jpegData(compressionQuality: 0.7) else { return .requestPlain }
            formData.append(MultipartFormData(
                provider: .data(imageData),
                name: "file",
                fileName: "image.jpg",
                mimeType: "image/jpeg"
            ))
            
            formData.append(MultipartFormData(
                provider: .data((User.shared.data?.id ?? "").data(using: .utf8)!),
                name: "userId"
            ))
            
            formData.append(MultipartFormData(
                provider: .data(type.key.data(using: .utf8)!),
                name: "type"
            ))
            
            
            return .uploadMultipart(formData)
        }
    }
    
    
    
}

class ThreeVerifyData: Encodable {
    
    let userId: String = User.shared.data?.id ?? ""
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
