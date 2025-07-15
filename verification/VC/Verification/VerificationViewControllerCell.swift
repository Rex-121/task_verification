//
//  VerificationViewControllerCell.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import UIKit

class VerificationViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var desLabel: UILabel?
    @IBOutlet weak var indexLabel: UILabel?
    
    
    var type: VerificationTypes? {
        didSet {
            let value = type?.display
            title?.text = value?.title
            desLabel?.text = value?.des
            indexLabel?.text = String(format: "%02d", type?.rawValue ?? 0)
        }
    }
    
}
