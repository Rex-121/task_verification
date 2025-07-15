//
//  EmergencyData.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class EmergencyData {
    
    public var dic: [EmergencyType: String]
    
    init() {
        self.dic = [:]
        EmergencyType.allCases.forEach { type in
            self.dic[type] = ""
        }
    }
    
}


extension EmergencyData: ReactiveExtensionsProvider { }

extension Reactive where Base == EmergencyData {
    
    func value(_ type: EmergencyType) -> BindingTarget<String> {
        return makeBindingTarget { base, value in
            base.dic[type] = value
        }
    }
    
}
