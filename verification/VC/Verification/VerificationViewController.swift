//
//  VerificationViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class VerificationViewController: UIViewController {
    
    let types = VerificationTypes.allCases
    let manager = VerifyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "认证"
        
        let item = UIBarButtonItem(title: "Close", style: .plain, target: nil, action: #selector(d))
//        let item = UIBarButtonItem(systemItem: .close)
        
        navigationItem.rightBarButtonItem = item
        
        item.action = #selector(d)
        
        // 请求定位权限
        LocationManager.shared.requestLocationPermission()
      
        
        
        manager.start()
    }
    
    @objc func d() {
        print("fdasd")
    }
    
    static var verificationVC: UIViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationViewController")
    }
}

extension VerificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = types[indexPath.section]
        
        switch cell {
            
        case .threeObjects:
            navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyThreeObjectsViewController"), animated: true)
        case .contacts:
            
            ContactsManager.shared.start { [weak self] contacts in
                self?.manager.verifyContacts(contacts)
            }
            
            break
        case .idCard:
            navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IDCardVerifyViewController"), animated: true)
            break
        case .facialDetector:
            navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FacialVC"), animated: true)
            break
        }
        
    }
    
}



extension VerificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VerificationViewControllerCell") as! VerificationViewControllerCell
        
        let type = types[indexPath.section]
        cell.type = type
        
        cell.reactive.status <~ manager.status.producer.take(until: cell.reactive.prepareForReuse)
            .map { $0?.status(by: type) }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return types.count
    }
    
}
