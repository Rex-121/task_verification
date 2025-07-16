//
//  VerificationViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import UIKit

class VerificationViewController: UIViewController {
    
    let types = VerificationTypes.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "认证"
        
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
        case .idCard:
            break
        case .facialDetector:
            break
        }
        
    }
    
}



extension VerificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VerificationViewControllerCell") as! VerificationViewControllerCell
        
        cell.type = types[indexPath.section]
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return types.count
    }
    
}
