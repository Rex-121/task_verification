//
//  F.swift
//  boss_interview_demo
//
//  Created by Tyrant on 2025/6/20.
//

import Foundation

protocol VerificationBaseNet: AnvilTargetType {

    
}

extension VerificationBaseNet {
    var baseURL: URL  { URL(string: Info.host)! }
    
    var headers: [String : String]? { nil }
     
}
