//
//  VerificationViewControllerCell.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class VerificationViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var desLabel: UILabel?
    @IBOutlet weak var indexLabel: UILabel?
    @IBOutlet weak var statusLabel: UILabel?
    
    var type: VerificationTypes? {
        didSet {
            let value = type?.display
            title?.text = value?.title
            desLabel?.text = value?.des
            indexLabel?.text = String(format: "%02d", type?.rawValue ?? 0)
        }
    }
    
}

extension Reactive where Base == VerificationViewControllerCell {
    
    var status: BindingTarget<Bool?> {
        return makeBindingTarget { base, value in
            if value == nil { return }
            
            guard let verified = value else { return }
            
            base.statusLabel?.textColor = verified ? UIColor.green : UIColor.gray
            base.statusLabel?.text = verified ? "已认证" : "未认证"
            
        }
    }
    
}
