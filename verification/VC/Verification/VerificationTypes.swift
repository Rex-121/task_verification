//
//  VerificationStatus.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation


enum VerificationTypes: Int, CaseIterable {
    
    /// 二要素
    case twoObjects = 1
    
    case idCard = 3
    
    case facialDetector = 4
    
}

extension VerificationTypes {
    
    var display: (title: String, des: String) {
        switch self {
        case .twoObjects: return ("二要素认证", "认证您的姓名和身份证号")
        case .idCard:  return ("身份证认证", "请上传身份证正反面")
        case .facialDetector:  return ("人脸识别", "进行人脸识别")
        }
    }
    
}
