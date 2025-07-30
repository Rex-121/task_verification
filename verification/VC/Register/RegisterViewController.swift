//
//  RegisterViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import ProgressHUD
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
                
        
//        registerAction.values.observeValues { [weak self] v in
//            print(v)
//            if v.success {
//                self?.dismiss(animated: true)
//            }
//        }
        
        reactive.toast(0.5) <~ registerAction.errors.map { $0.description }
        reactive.toast(0.5) <~ registerAction.values.map { $0.description }

        registerBtn.reactive.pressed = CocoaAction(registerAction, input: .register(registerData))
        
        registerAction.values.delay(0.5, on: QueueScheduler())
            .observeValues { [weak self] _ in
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self?.navigationController?.popViewController(animated: true)
                }
                
            }
        reactive.progressHud <~  registerAction.isExecuting
//        registerAction.isExecuting.producer
//            .observe(on: QueueScheduler.main)
//            .startWithValues { isExecuting in
//            if isExecuting {
//                ProgressHUD.animate(nil, .activityIndicator, interaction: false)
//            } else {
//                ProgressHUD.dismiss()
//            }
//        }
    }
}
