//
//  RegisterBaseData.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation

import ReactiveSwift
import ReactiveCocoa

class RegisterBaseData {
    
    public var dic: [RegisterCellType: String]
    
    let emergency = EmergencyData()
    
    init() {
        self.dic = [:]
        RegisterCellType.allCases.forEach { type in
            switch type {
            case .emergency(_):
                break
            default:
                self.dic[type] = ""
            }
        }
    }
    
    
    func getData() {
        
        
        
    }
    
}


extension RegisterBaseData: ReactiveExtensionsProvider { }

extension Reactive where Base == RegisterBaseData {
    
    
    func value(_ type: RegisterCellType) -> BindingTarget<String> {
        makeBindingTarget { base, value in
            switch type {
            case .emergency(let emergencyType):
                base.emergency.dic[emergencyType] = value
            default:
                base.dic[type] = value
                break
            }
        }
    }
    
}


extension RegisterBaseData: Encodable {
    
    func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: RegisterCodingKeys.self)
        
        for value in dic {
            try container.encode(value.value, forKey: value.key.codingKey)
        }
        
        for value in emergency.dic {
            try container.encode(value.value, forKey: value.key.codingKey)
        }
    }
    
}

/**
 1. userName -> 昵称
    2. userPhone -> 手机号
    3. userPwd -> 密码
    4. userCard -> 身份证号
    5. contactName -> 紧急联系人姓名
    6. contactPhone -> 紧急联系人电话
    7. contactName1 -> 紧急联系人姓名1
    8. contactPhone1 -> 紧急联系人电话1
    9. contactName2  -> 紧急联系人姓名2
    10. contactPhone2 -> 紧急联系人电话2
    11. familyAddress -> 家庭地址
    12. unitAddress -> 单位地址
    13. address -> 定位信息 (没有值传"")
    14. lon -> 经纬度 (没有值传"")
    15. lat -> 经纬度 (没有值传"")
 */

private enum RegisterCodingKeys: CodingKey, CaseIterable {
  case userName, userPwd, userCard, userPhone
    case contactName, contactName1, contactName2, contactPhone, contactPhone1, contactPhone2
    case familyAddress, unitAddress
    case address
    case lon, lat
}

private extension RegisterCellType {
var codingKey: RegisterCodingKeys {
    switch self {
    case .name: return .userName
    case .phone: return .userPhone
    case .id: return .userCard
    case .password: return .userPwd
    case .emergency(let emergencyType):
        return emergencyType.codingKey
    case .address: return .familyAddress
    case .workAddress: return .unitAddress
    }
}
}
private extension EmergencyType {
    var codingKey: RegisterCodingKeys {
        switch self {
        case .name:
            return .contactName
        case .phone:
            return .contactPhone
        case .name1:
            return .contactName1
        case .phone1:
            return .contactPhone1
        case .name2:
            return .contactName2
        case .phone2:
            return .contactPhone2
        }
    }
}
