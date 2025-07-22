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
    
    case upload(VerifyUploadable)
    
    case verifyStatus
}

enum VerifyUploadable {
    
    case location(lon: Double, lat: Double)
    case idCard(IDCardVerifyViewController.IDType, UIImage)
    case contacts(_ contacts: ContactUpload)
}

extension VerifyUploadable: VerificationBaseNet {
    var path: String {
        switch self {
        case .location:
            return "/gw/user-app/local"
        case .idCard:
            return "/gw/upload/card"
        case .contacts:
            return "/gw/app-book"
        }
    }
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case let .location(lon: lon, lat: lat):
            
            /*
             1. id -> 用户id
                 2. address -> 定位信息
                 3. lon -> 经纬度
                 4. lat -> 经纬度
             */
            struct LocationData: Encodable {
                let id = User.shared.data?.id ?? ""
                let lon: Double
                let lat: Double
            }
            return .requestJSONEncodable(LocationData(lon: lon, lat: lat))
        case let .contacts(data):
            return .requestJSONEncodable(data)
        case let .idCard(type, image):
            
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

extension VerifyNet: VerificationBaseNet {
    var path: String {
        
        switch self {
        case .three:
            return "/gw/identity/3"
        case .upload(let upload):
            return upload.path
        case .verifyStatus:
            return "/gw/user-app/identity"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .three, .verifyStatus:
            return .get
        case .upload(let upload): return upload.method
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .three(let data):
            return .requestParameters(parameters: data.dic,
                                      encoding: URLEncoding())
        case let .upload(upload): return upload.task
        case .verifyStatus:
            return .requestParameters(parameters: ["userId": User.shared.data?.id ?? ""], encoding: URLEncoding())
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
