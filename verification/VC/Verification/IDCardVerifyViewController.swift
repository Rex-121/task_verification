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
        
        reactive.toast <~ manager.verifyThreeAction.errors.map { $0.description }
            .merge(with: manager.verifyThreeAction.values.map { $0.msg })
    }
    
    fileprivate var choosend = IDType.front
    
    
    func didChooseImage(_ image: UIImage) {
        
        switch choosend {
        case .front:
            self.frontId?.image = image
        case .back:
            self.backId?.image = image
        }
        
        manager.verifyThreeAction.apply(.uploadIdCard(choosend, image)).start()
        
    }
    
    @IBAction func front(_ s: UIButton) {
        presentPHPicker(.front)
    }
    
    @IBAction func back(_ s: UIButton) {
        presentPHPicker(.back)
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
        }
        picker.dismiss(animated: true)
    }
}
