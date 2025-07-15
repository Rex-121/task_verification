//
//  RegisterViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    let types = RegisterCellType.allCases

    let registerData = RegisterBaseData()
    
    let net = VerificationBaseNetProvider<RegisterNet>()
        
    lazy var registerAction: Action<RegisterNet, BasicInfo, AnvilNetError> = {
        return Action { [unowned self] model in
            return self.net.brief(model)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for value in types {
            tableView.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: value.title)
        }
        
//        reactive
        
        
        registerAction.values.observeValues { [weak self] v in
            print(v)
            if v.success {
                self?.dismiss(animated: true)
            }
        }
        
        registerAction.errors.observeValues { v in
            print(v)
        }
        
        registerBtn.reactive.pressed = CocoaAction(registerAction, input: .register(registerData))
    }
}
