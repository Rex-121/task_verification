//
//  RegisterTableViewCell.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import UIKit

class RegisterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var input: UITextField!
    
    
    var type: RegisterCellType? {
        didSet {
            title.text = type?.title
            input.placeholder = "请输入" + (title.text ?? "")
        }
    }
    
}
