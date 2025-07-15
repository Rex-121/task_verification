//
//  LoginManager.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class LoginManager {
    
    
    let net = VerificationBaseNetProvider<RegisterNet>()
        
    lazy var loginAction: Action<RegisterNet, BasicInfo, AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.brief(model)
        }
    }()
    
    var data = LoginBaseData(userPhone: "", userPwd: "")
    
}

struct LoginBaseData: Encodable {
   
    /*
     1. userPhone -> 手机号
     2. userPwd -> 密码
     */
    
    let userPhone: String
    
    let userPwd: String
    
}

extension LoginManager: ReactiveExtensionsProvider { }
extension Reactive where Base == LoginManager {
    
    
    var info: BindingTarget<(name: String, psw: String)> {
        makeBindingTarget { base, value in
            base.data = LoginBaseData(userPhone: value.name, userPwd: value.psw)
        }
    }
    
}
