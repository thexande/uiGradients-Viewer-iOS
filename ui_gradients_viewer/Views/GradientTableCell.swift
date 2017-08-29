//
//  GradientTableCell.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/28/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

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
