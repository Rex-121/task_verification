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
import PhotosUI
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
        
        
    
        navigationController?.reactive.removeLastThenPush <~ manager.loginAction
            .values
            .filter { $0.success }
            .map({ _ in
                VerificationViewController.verificationVC
        })
        
        reactive.toast <~ manager.loginAction.allMessages
        
        loginBtn.reactive.pressed = CocoaAction(manager.loginAction, { [unowned self] _ in
                .login(self.manager.data)
        })
    }

    
    func presentPHPicker() {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1 // 选择1张图片
            configuration.filter = .images // 只选图片
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
        self.navigationController?.present(picker, animated: true)
        }


}


extension ViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImageSourceOptions() {
        let alert = UIAlertController(title: "选择图片来源", message: nil, preferredStyle: .actionSheet)
        
        // 相册选项
        alert.addAction(UIAlertAction(title: "相册", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }))
        
        // 相机选项（检查设备是否支持相机）
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { _ in
                self.presentImagePicker(sourceType: .camera)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }

    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
           picker.dismiss(animated: true)
           
           guard let result = results.first else { return }
           
           result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
               if let image = object as? UIImage {
                   DispatchQueue.main.async {
                       print(image)
//                       self?.imageView.image = image
                   }
               }
           }
       }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
//                imageView.image = image
                print(image)
            }
            picker.dismiss(animated: true)
        }
}
