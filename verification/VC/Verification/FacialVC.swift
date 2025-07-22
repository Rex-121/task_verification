//
//  FacialVC.swift
//  verification
//
//  Created by Tyrant on 2025/7/18.
//

import UIKit

import ReactiveSwift
import  ReactiveCocoa

class FacialVC: UIViewController {
    
    let cells = [RegisterCellType.name, .id]

    let manager = FacialDetectorManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "认证"
        
        for value in cells {
            tableView.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: value.title)
        }
        
        
        let vc = manager.getVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}


extension FacialVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= cells.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VerifyThreeWithFacialCellButton", for: indexPath) as! VerifyThreeWithFacialCellButton
            
            cell.btn.reactive.pressed = CocoaAction(manager.verifyThreeAction, { [unowned self] _ in
                return .three(self.manager.data)
            })
            
            cell.idImageView.reactive.image <~ manager.image.signal.take(until: cell.reactive.prepareForReuse)
            
            return cell
        }
        
        
        let type = cells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: type.title, for: indexPath) as! RegisterTableViewCell
        
        cell.type = type
        
        switch type {
            
        case .name:
            manager.reactive.binding(for: \.data.name) <~ cell.input.reactive.continuousTextValues.take(until: cell.reactive.prepareForReuse)
        case .id:
            manager.reactive.binding(for: \.data.idCard) <~ cell.input.reactive.continuousTextValues.take(until: cell.reactive.prepareForReuse)
        default:
            break
        }
        
        return cell
    }
    
    
    
    
}



extension FacialVC: LiveDetectControllerDelegate {
    func onFailed(_ code: Int32, withMessage message: String) {
        view.makeToast(message)
    }
    
    func onCompleted(_ live: Bool, with imageData: Data, rect faceRect: CGRect) {
        
        if live {
            manager.image.swap(UIImage(data: imageData))
        }
    }
    
}



class VerifyThreeWithFacialCellButton: UITableViewCell {
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var idImageView: UIImageView!
    
}
