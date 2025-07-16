//
//  ViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/14.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
//import liv
//import YPImagePicker
import Toast_Swift


class ViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var psdText: UITextField!
    
    let manager = LoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let liveVc = LiveDetectController()
        
        
//        LiveDetectController *liveVc = [[LiveDetectController alloc]init];

        // Do any additional setup after loading the view.
        
        let info = nameText.reactive.continuousTextValues.combineLatest(with: psdText.reactive.continuousTextValues).map { (name: $0, psw: $1) }
        
        manager.reactive.info <~ info.take(during: reactive.lifetime)
        
        
        navigationController?.reactive.removeLastThenPush <~ User.shared.loginSignal.signal
            .take(during: reactive.lifetime)
            .map { _ in VerificationViewController.verificationVC }
    
        User.shared.reactive.login <~ manager.loginAction
            .values
            .filter { $0.1.success }
            .map { $0.0 }
        
        reactive.toast <~ manager.loginAction.errors.map { $0.description }
        
        loginBtn.reactive.pressed = CocoaAction(manager.loginAction, { [unowned self] _ in
                .login(self.manager.data)
        })
    }


}

