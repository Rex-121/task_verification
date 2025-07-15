//
//  RegisterViewController+TableView.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: types[indexPath.row].title, for: indexPath) as! RegisterTableViewCell
        
        cell.type = types[indexPath.row]
        
        registerData.reactive.value(cell.type!) <~ cell.input.reactive.continuousTextValues.take(until: cell.reactive.prepareForReuse)
        
        return cell
    }
    
}
