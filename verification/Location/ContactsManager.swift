//
//  ContactsManager.swift
//  verification
//
//  Created by Tyrant on 2025/7/16.
//

import Foundation
import Contacts
import ReactiveSwift


class ContactsManager {
    
    static let shared = ContactsManager()
    
    let net = VerificationBaseNetProvider<VerifyNet>()
    
    func start(completion: @escaping ([ContactData]) -> Void) {
        DispatchQueue.main.async {
            
            ContactsManager.shared.requestContactsAccess { b in
                print("获取通讯录 \(b)")
                
                ContactsManager.shared.fetchContacts { [weak self] con, _ in
                    completion(con?.map { ContactData(c: $0) } ?? [])
//                    self?.to(con?.map { ContactData(c: $0) })
                }
            }
        }
        
    }
    
//    func to(_ all: [ContactData]?) -> SignalProducer<(), AnvilNetError> {
////        guard let all = all, !all.isEmpty else { return }
//        
//        print(all)
//        return self.net.detach(.upload(.contacts(ContactUpload(param: all ?? []))))
//            .retry(upTo: 3, interval: 3, on: QueueScheduler())
////            .start()
//    }
    
    func requestContactsAccess(completion: @escaping (Bool) -> Void) {
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("通讯录访问请求错误: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(granted)
                    }
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    func fetchContacts(completion: @escaping ([CNContact]?, Error?) -> Void) {
        let store = CNContactStore()
        let keysToFetch = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            //            CNContactEmailAddressesKey as CNKeyDescriptor,
            //            CNContactThumbnailImageDataKey as CNKeyDescriptor
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        DispatchQueue.global(qos: .background).async {
            
            do {
                var contacts = [CNContact]()
                
                try store.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
                completion(contacts, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}


struct ContactUpload: Encodable {
    
    let userId = User.shared.data?.id ?? ""
    
    let param: [ContactData]
    
}

struct ContactData: Encodable {
    
    let name: String
    let phone: String
    
    init(c: CNContact) {
        name = c.familyName + c.givenName
        
        var p = ""
        
        for labeledValue in c.phoneNumbers {
            // 获取电话号码标签（类型）
            if let label = labeledValue.label {
                let localizedLabel = CNLabeledValue<NSString>.localizedString(forLabel: label)
                
                if label == CNLabelPhoneNumberMobile {
                    // 获取电话号码对象
                    let phoneNumber = labeledValue.value
                    
                    // 获取字符串形式的电话号码
                    p = phoneNumber.stringValue
                    
                    break
                }
            }
        }
        
        phone = p
        
    }
    
}
