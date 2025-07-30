//
//  ViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/14.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var psdText: UITextField!
    
    let manager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        reactive.progressHud <~ manager.loginAction.isExecuting
        
        
//        loginBtn.reactive.controlEvents(.touchUpInside)
//            .observeValues { [weak self] _ in
//                self?.presentImagePicker(sourceType: .camera)
//            }
        
    }
    
    
}



import PhotosUI

extension ViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func presentPHPicker() {

        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // 选择1张图片
        configuration.filter = .images // 只选图片
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.navigationController?.present(picker, animated: true)
    }
    
    
    
    func presentImageSourceOptions() {
        let alert = UIAlertController(title: "选择图片来源", message: nil, preferredStyle: .actionSheet)
        
        // 相册选项
        alert.addAction(UIAlertAction(title: "相册", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }))
        
        // 相机选项（检查设备是否支持相机）
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: { _ in
                self.presentImagePicker(sourceType: .camera)
            }))
//        }
        
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
                    print("fasdf")
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //                imageView.image = image
            print(image)
            print(compressImageWithImageIO(image: image))
        }
        picker.dismiss(animated: true)
    }
    
    func checkCameraPermissions() {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch status {
            case .authorized:
                break
            case .notDetermined:
                break
            case .denied, .restricted:
                break
            @unknown default:
                break
            }
        }
    
    func compressImageWithImageIO(image: UIImage, maxSizeKB: Int = 100) -> Data? {
        let maxSizeBytes = maxSizeKB * 1024
        var imageData = image.jpegData(compressionQuality: 1.0)
        
        guard let sourceData = imageData else { return nil }
        
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: 1024 // 设置最大尺寸
        ]
        
        guard let source = CGImageSourceCreateWithData(sourceData as CFData, nil),
              let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }
        
        let compressedImage = UIImage(cgImage: cgImage)
        var resultData = compressedImage.jpegData(compressionQuality: 0.7)
        
        // 如果仍然太大，调整压缩质量
        var quality: CGFloat = 0.7
        while (resultData?.count ?? 0) > maxSizeBytes && quality > 0.1 {
            quality -= 0.1
            resultData = compressedImage.jpegData(compressionQuality: quality)
        }
        
        return resultData
    }

}
