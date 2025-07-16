//
//  VerifyThreeManager.swift
//  verification
//
//  Created by Tyrant on 2025/7/16.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class VerifyThreeManager {
    
    
    let net = VerificationBaseNetProvider<VerifyNet>()
        
    lazy var verifyThreeAction: Action<VerifyNet, BasicInfo, AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.brief(model)
        }
    }()
    
    var data = ThreeVerifyData()
    
}

extension VerifyThreeManager: ReactiveExtensionsProvider { }
