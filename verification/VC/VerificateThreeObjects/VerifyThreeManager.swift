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
        
    lazy var verifyThreeAction: Action<VerifyNet, VerifyThreeResponse, AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.detach(model, VerifyThreeResponse.self)
        }
    }()
    
    var data = ThreeVerifyData()
    
}

extension VerifyThreeManager: ReactiveExtensionsProvider {
}

struct VerifyThreeResponse: Decodable {
    /**
     "msg": "身份证不合法",
             "code": 400,
             "data": null,
             "success": false
     */
    
    let msg: String?
    let code: Int
}
