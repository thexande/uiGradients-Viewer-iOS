//
//  SelectGradientViewController.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/28/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class SelectGradientHeader: UIView {
    let imageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "uig_glyph"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-60-[image]-60-|", options: [], metrics: nil, views: ["image":imageView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[image]-60-|", options: [], metrics: nil, views: ["image":imageView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SelectGradientViewController: UITableViewController {
    var gradients: [GradientColor]?
    
    let backgroundView: UIView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func cellFactory(_ gradient: GradientColor) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuse")
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.textLabel?.text = gradient.title
        
        let gradColors = gradient.colors.map({ (stringDict) -> String? in
            return stringDict.keys.first
        }).flatMap({ $0 }).map({ $0.uppercased() }).joined(separator: ", ")
        
        cell.detailTextLabel?.text = gradColors
        cell.detailTextLabel?.textColor = .white
        cell.textLabel?.textColor = .white
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableView.backgroundView = backgroundView
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = SelectGradientHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 114, height: 18))
        imageView.image = #imageLiteral(resourceName: "uigradients")
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.barTintColor = .black
     
        
        
        let navItemImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        navItemImageView.image = #imageLiteral(resourceName: "close_menu").withRenderingMode(.alwaysTemplate)
        navItemImageView.contentMode = .scaleAspectFit
        navItemImageView.tintColor = .white
        navItemImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navItemImageView)
        
        _ = GradientHelper.produceGradients { [weak self] (gradients) in
            guard let strongSelf = self else { return }
            strongSelf.gradients = gradients
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectGradientViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presentingViewController?.childViewControllers.first as? RootPageViewController else { return }
        dismiss(animated: true) { 
            presenter.scrollToPage(.at(index: indexPath.row), animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let gradients = gradients else { return UITableViewCell() }
        let cell = cellFactory(gradients[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gradients = gradients else { return 0 }
        return gradients.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
