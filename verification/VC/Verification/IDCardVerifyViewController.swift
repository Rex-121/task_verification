//
//  IDCardVerifyViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/16.
//

import Foundation
import PhotosUI
import ReactiveSwift
import ReactiveCocoa
import ProgressHUD

class IDCardVerifyViewController: UIViewController {
    
    @IBOutlet weak var frontId: UIImageView?
    @IBOutlet weak var backId: UIImageView?
    let manager = IDCardUploadManager()
    enum IDType {
        case front, back
        
        var key: String {
            switch self {
            case .front: return "1"
            case .back: return "2"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactive.toast(0.5) <~ manager.verifyThreeAction.errors.map { $0.description }
            .merge(with: manager.verifyThreeAction.values.map { $0.msg })
        
        manager.verifyThreeAction.isExecuting.producer
            .observe(on: QueueScheduler.main)
            .startWithValues { isExecuting in
            if isExecuting {
                ProgressHUD.animate(nil, .activityIndicator, interaction: false)
            } else {
                ProgressHUD.dismiss()
            }
        }
    }
    
    fileprivate var choosend = IDType.front
    
    
    func didChooseImage(_ image: UIImage) {
        
        switch choosend {
        case .front:
            self.frontId?.image = image
        case .back:
            self.backId?.image = image
        }
        
        let data = compressImageWithImageIO(image: image) ?? Data()
        
        manager.verifyThreeAction.apply(.upload(.idCard(choosend, data))).start()
        
//        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    @IBAction func front(_ s: UIButton) {
        checkCameraPermissions(.front)
    }
    
    @IBAction func back(_ s: UIButton) {
        checkCameraPermissions(.back)
    }
    
    
}



extension IDCardVerifyViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func presentPHPicker(_ type: IDType) {
        choosend = type

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
                    self?.didChooseImage(image)
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //                imageView.image = image
            print(image)
            self.didChooseImage(image)
        }
        picker.dismiss(animated: true)
    }
    
    func checkCameraPermissions(_ type: IDType) {
        choosend = type
            let status = AVCaptureDevice.authorizationStatus(for: .video)

            switch status {
            case .authorized:
                presentImageSourceOptions()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] r in
                    if r {
                        DispatchQueue.main.async {
                            self?.presentImageSourceOptions()
                        }
                    }
                }
                break
            case .denied, .restricted:
                presentImageSourceOptions()
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
