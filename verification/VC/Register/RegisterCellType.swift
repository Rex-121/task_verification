//
//  RegisterCellType.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation


enum RegisterCellType{
    
    
    
    
    case name, phone, id, password
    case emergency(EnergencyType)
    case address, workAddress
    
    
}

extension RegisterCellType: CaseIterable {
    
    static var allCases: [RegisterCellType] {
        var cases:[RegisterCellType] =
        [.name, .phone, .id, .password]
        
        cases.append(contentsOf: EnergencyType.allCases.map { RegisterCellType.emergency($0) })
        
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
    
}



enum EnergencyType: CaseIterable {
    case name, phone
    case name1, phone1
    case name2, phone2
}

extension EnergencyType {
    var title: String {
        switch self {
        case .name:
            return "紧急联系人姓名"
        case .phone:
            return "紧急联系人电话"
        case .name1: return EnergencyType.name.title + "2"
        case .phone1: return EnergencyType.phone.title + "2"
        case .name2: return EnergencyType.name.title + "3"
        case .phone2: return EnergencyType.phone.title + "3"
        }
    }
}
