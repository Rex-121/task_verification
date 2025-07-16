//
//  VerifyThreeObjectsViewController.swift
//  verification
//
//  Created by Tyrant on 2025/7/16.
//

import UIKit
import ReactiveSwift
import  ReactiveCocoa

class VerifyThreeObjectsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
 
    let cells = [RegisterCellType.name, .phone, .id]
    
    let manager = VerifyThreeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "认证"
        
        for value in cells {
            tableView.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: value.title)
        }
        
        reactive.toast <~ manager.verifyThreeAction.allMessages
        
    }
    
}

extension VerifyThreeObjectsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= cells.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VerifyThreeCellButton", for: indexPath) as! VerifyThreeCellButton
            
            cell.btn.reactive.pressed = CocoaAction(manager.verifyThreeAction, { [unowned self] _ in
                return .three(self.manager.data)
            })
            
            return cell
        }
        
        
        let type = cells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: type.title, for: indexPath) as! RegisterTableViewCell
        
        cell.type = type
        
        switch type {
            
        case .name:
            manager.reactive.binding(for: \.data.name) <~ cell.input.reactive.continuousTextValues.take(until: cell.reactive.prepareForReuse)
                
        case .phone:
            manager.reactive.binding(for: \.data.mobile) <~ cell.input.reactive.continuousTextValues.take(until: cell.reactive.prepareForReuse)
        case .id:
            manager.reactive.binding(for: \.data.idCard) <~ cell.input.reactive.continuousTextValues.take(until: cell.reactive.prepareForReuse)
        default:
            break
        }
        
        return cell
    }
    
    
    
    
}



class VerifyThreeCellButton: UITableViewCell {
    
    @IBOutlet weak var btn: UIButton!
    
}
