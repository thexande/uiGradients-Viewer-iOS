//
//  ViewController.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/27/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import UIKit
import GradientView

class GradientTableCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureGradient(_ gradient: GradientColor) {
        let gradientView = GradientHelper.produceGradientView(gradient)
        contentView.insertSubview(gradientView, at: 0)
        titleLabel.text = gradient.title.uppercased()
        contentView.addSubview(titleLabel)
        
        let viewsDict = ["title":titleLabel, "grad":gradientView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-12-|", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[title]", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[grad]|", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[grad]|", options: [], metrics: nil, views: viewsDict))
    }
    
    override func prepareForReuse() {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }
}

class GradientDetailViewController: UIViewController {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(pressedBack), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "back_button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(gradient: GradientColor) {
        super.init(nibName: nil, bundle: nil)
        configureGradient(gradient)
        view.addSubview(backButton)
        
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 12),
            NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 12),
            
        ])
    }
    
    func pressedBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func configureGradient(_ gradient: GradientColor) {
        let gradientView = GradientHelper.produceGradientView(gradient)
        view.insertSubview(gradientView, at: 0)
        titleLabel.text = gradient.title.uppercased()
        view.addSubview(titleLabel)
        
        self.navigationController?.navigationBar.barTintColor = .black
        
        let viewsDict = ["title":titleLabel, "grad":gradientView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-12-|", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[title]", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[grad]|", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[grad]|", options: [], metrics: nil, views: viewsDict))
    }
    
}

class RootViewController: UITableViewController {
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
            strongSelf.gradients = gradients
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension RootViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gradients = gradients else { return }
        navigationController?.pushViewController(GradientDetailViewController(gradient: gradients[indexPath.row]), animated: true)
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

