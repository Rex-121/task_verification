//
//  IDCardUploadManager.swift
//  verification
//
//  Created by Tyrant on 2025/7/16.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class IDCardUploadManager {
    
    let net = VerificationBaseNetProvider<VerifyNet>()
        
    lazy var verifyThreeAction: Action<VerifyNet, VerifyThreeResponse, AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.detach(model, VerifyThreeResponse.self)
        }
    }()
    
    var data = ThreeVerifyData()
    
}
