//
//  User.swift
//  verification
//
//  Created by Tyrant on 2025/7/16.
//

import Foundation

import ReactiveCocoa
import ReactiveSwift

class User {
    
    var data: UserData? = nil
    
    let loginSignal: MutableProperty<Bool>
    
    static let shared = User()
    private init() {
        loginSignal = MutableProperty(data != nil)
    }
    
}
extension User {
    
    fileprivate func login(_ data: UserData?) {
        self.data = data
        loginSignal.swap(data != nil)
    }
    
}

extension User: ReactiveExtensionsProvider { }
extension Reactive where Base == User {
    
    var login: BindingTarget<UserData> {
        makeBindingTarget { $0.login($1) }
    }
    
}


struct UserData: Decodable {
    
    let id: String
    
}
