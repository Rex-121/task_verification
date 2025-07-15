//
//  RegisterViewController+TableView.swift
//  verification
//
//  Created by Tyrant on 2025/7/15.
//

import Foundation


extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableViewCell", for: indexPath) as! RegisterTableViewCell
        
        cell.type = types[indexPath.row]
        
        return cell
    }
    
}
