//
//  RootTableViewController.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/28/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class RootTableViewController: UITableViewController {
    var gradients: [GradientColor]?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(GradientTableCell.self, forCellReuseIdentifier: NSStringFromClass(GradientTableCell.self))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 114, height: 18))
        imageView.image = #imageLiteral(resourceName: "uigradients")
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.barTintColor = .black
        
        _ = GradientHelper.produceGradients { [weak self] (gradients) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.gradients = gradients
                strongSelf.tableView.reloadData()
            }
        }
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension RootTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gradients = gradients else { return }
        navigationController?.pushViewController(GradientDetailViewController(gradients[indexPath.row]), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let gradients = gradients else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(GradientTableCell.self)) as? GradientTableCell else { return UITableViewCell() }
        cell.configureGradient(gradients[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gradients = gradients else { return 0 }
        return gradients.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
