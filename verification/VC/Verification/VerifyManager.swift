//
//  VerifyManager.swift
//  verification
//
//  Created by Tyrant on 2025/7/22.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class VerifyManager {
    
    
    let net = VerificationBaseNetProvider<VerifyNet>()
    
    
    lazy var getStatus: Action<(), VerifyStatus, AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.detach(.verifyStatus, VerifyStatus.self)
        }
    }()
    
    lazy var getContacts: Action<[ContactData], (), AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.detach(.upload(.contacts(ContactUpload(param: model)))).retry(upTo: 3, interval: 3, on: QueueScheduler())
        }
    }()
    
    let status = MutableProperty<VerifyStatus?>(nil)
    
    init() {
        status <~ getStatus.values
        
        getStatus.errors.observeValues { print($0) }
        
        getContacts.values.observeValues { v in
            print(v)
        }
        
        getContacts.errors.observeValues { v in
            print(v)
        }
        
        getStatus <~ getContacts.values
    }
    
    func verifyContacts(_ contact: [ContactData]) {
        getContacts.apply(contact).start()
    }
    
    func start() {
        getStatus.apply().retry(upTo: 30, interval: 3, on: QueueScheduler()).start()
    }
    
}

/**
 private int bookState; -> 通讯录

 private int smsState; -> 短信

 private int callState; -> 通话记录

 private int appState; -> app列表

 private int identity2; -> 二要素

 private int identity3; -> 三要素

 private int identity4; -> 身份证
 */
struct VerifyStatus: Decodable {
    
    let identity3: Int
    
    let bookState: Int
    
    let identity4: Int
    
    let identity5: Int
    
//    private enum CodingKeys: CodingKey {
//        
//    }
//    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//    }
    
    func status(by type: VerificationTypes) -> Bool {
        switch type {
        case .threeObjects:
            return identity3 == 1
        case .contacts:
            return bookState == 1
        case .idCard:
            return identity4 == 1
        case .facialDetector:
            return identity5 == 1
        }
    }
    
}
