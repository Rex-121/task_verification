//
//  RegisterCellType.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation


enum RegisterCellType: Hashable {
    
    
    
    case name, phone, id, password
    case emergency(EmergencyType)
    case address, workAddress
    
    
}

extension RegisterCellType: CaseIterable {
    
    static var allCases: [RegisterCellType] {
        var cases:[RegisterCellType] =
        [.name, .phone, .id, .password]
        
        cases.append(contentsOf: EmergencyType.allCases.map { RegisterCellType.emergency($0) })
        
        cases.append(contentsOf: [.address, .workAddress])
        
        return cases
    }
    
    var title: String {
        
        switch self {
        case .name: return "姓名"
        case .phone: return "手机号"
        case .id: return "身份证"
        case .password: return "密码"
        case .emergency(let energencyType):
            return energencyType.title
        case .address: return "家庭住址"
        case .workAddress: return "单位地址"
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
    
    var key: String {
        switch self {
        case .name: return "userName"
        case .phone: return "userPhone"
        case .id: return "userCard"
        case .password: return "userPwd"
        case .emergency(let energencyType):
            return energencyType.key
        case .address: return "familyAddress"
        case .workAddress: return "unitAddress"
        }
    }
    
}



enum EmergencyType: CaseIterable {
    case name, phone
    case name1, phone1
    case name2, phone2
}

extension EmergencyType {
    var title: String {
        switch self {
        case .name:
            return "紧急联系人姓名"
        case .phone:
            return "紧急联系人电话"
        case .name1: return EmergencyType.name.title + "2"
        case .phone1: return EmergencyType.phone.title + "2"
        case .name2: return EmergencyType.name.title + "3"
        case .phone2: return EmergencyType.phone.title + "3"
        }
    }
    
    /**
     5. contactName -> 紧急联系人姓名
     6. contactPhone -> 紧急联系人电话
     7. contactName1 -> 紧急联系人姓名1
     8. contactPhone1 -> 紧急联系人电话1
     9. contactName2  -> 紧急联系人姓名2
     10. contactPhone2 -> 紧急联系人电话2
     */
    
    var key: String {
        switch self {
        case .name:
            return "contactName"
        case .phone:
            return "contactPhone"
        case .name1: return EmergencyType.name.title + "1"
        case .phone1: return EmergencyType.phone.title + "1"
        case .name2: return EmergencyType.name.title + "2"
        case .phone2: return EmergencyType.phone.title + "2"
        }
    }
}
