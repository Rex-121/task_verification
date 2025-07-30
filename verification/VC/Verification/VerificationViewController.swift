//
//  VerificationViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import ProgressHUD

class VerificationViewController: UIViewController {
    
    let types = VerificationTypes.allCases
    let manager = VerifyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "认证"
        
        let item = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(d))
//        let item = UIBarButtonItem(systemItem: .close)
        
        navigationItem.rightBarButtonItem = item
        
//        item.action = #selector(d)
        
        manager.getStatus <~ LocationManager.shared.sendLocation.values
            .delay(0.5, on: QueueScheduler())
      
//
        reactive.progressHud <~ manager.getStatus.isExecuting
        reactive.progressHud <~ manager.getContacts.isExecuting
        reactive.progressHud <~ LocationManager.shared.sendLocation.isExecuting
        reactive.progressHud <~ manager.getContacts.isExecuting
        
        
        
        let close = SignalProducer.timer(interval: .seconds(3), on: QueueScheduler.main)
            .take(first: 1)
        
        manager.status
            .signal
            .skipNil()
            .filter { $0.allVerified }
            .take(first: 1)
            .delay(1, on: QueueScheduler.main)
            .observe(on: QueueScheduler.main)
            .attempt({ r in
                DispatchQueue.main.async {
                    ProgressHUD.animate("APP禁止使用", .activityIndicator, interaction: false)
                }
                return .success(())
            })
            .producer
            .then(close)
            .take(first: 1)
            .startWithValues { [weak self] _ in
                self?.d()
            }
        
        
        manager.start()
        
    }
    
    @objc func d() {
        print("fdasd")
        exit(0)
    }
    
    static var verificationVC: UIViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationViewController")
    }
    
    var b: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("fadsdfasdf")
       

        if b {
            manager.start()
        }
        
        b = true
        
    }
}

extension VerificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = types[indexPath.section]
        
        guard let status = manager.status.value else { return }
        
        let still = status.status(by: cell)
        
        if still { return }
        
        switch cell {
            
        case .location:
            LocationManager.shared.requestLocationPermission()
            
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
