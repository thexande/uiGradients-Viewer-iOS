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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureGradient(_ gradient: GradientColor) {
        let gradientView = produceGradientView(gradient)
        contentView.addSubview(gradientView)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[grad]|", options: [], metrics: nil, views: ["grad":gradientView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[grad]|", options: [], metrics: nil, views: ["grad":gradientView]))
    }
    
    func produceGradientView(_ gradient: GradientColor) -> GradientView {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        let colors = gradient.colors.map({ (colorDict) -> UIColor? in
            return colorDict.values.first
        }).flatMap({ $0 })
        
        gradientView.colors = colors
        return gradientView
    }
}

class RootViewController: UITableViewController {
    var gradients: [GradientColor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        tableView.register(GradientTableCell.self, forCellReuseIdentifier: NSStringFromClass(GradientTableCell.self))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.title = "woot"
        
        
        GradientHelper.produceGradients { [weak self] (gradients) in
            guard let strongSelf = self else { return }
            strongSelf.gradients = gradients
            strongSelf.tableView.reloadData()
        }
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
        return 200
    }
}

