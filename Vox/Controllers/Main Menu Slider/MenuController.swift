//
//  MenuController.swift
//  Vox
//
//  Created by Skander Thabet on 2/5/2022.
//

import UIKit

class MenuController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .blue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        var content = cell.defaultContentConfiguration()
        content.text = "Menu : \(indexPath.row)"
        cell.contentConfiguration = content
        return cell
    }

    

}
