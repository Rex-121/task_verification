//
//  VerificationStatus.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation


enum VerificationTypes: Int, CaseIterable {
    
    case location = 1
    /// 三要素
    case threeObjects = 2
    
    case contacts = 3
    
    case idCard = 4
    
    case facialDetector = 5
    
}

extension VerificationTypes {
    
    var display: (title: String, des: String) {
        switch self {
        case .location: return ("位置信息", "获取您的位置信息")
        case .threeObjects: return ("三要素认证", "认证您的姓名和身份证号")
        case .contacts: return ("通讯录", "提交通讯录信息")
        case .idCard:  return ("身份证认证", "请上传身份证正反面")
        case .facialDetector:  return ("人脸识别", "进行人脸识别")
        }
    }
    
}
