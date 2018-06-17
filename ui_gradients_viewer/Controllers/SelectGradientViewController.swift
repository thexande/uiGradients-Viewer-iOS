//
//  SelectGradientViewController.swift
//  ui_gradients_viewer
//
//  Created by Alexander Murphy on 8/28/17.
//  Copyright © 2017 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit
import Anchorage
import ChromaColorPicker
import Pulley

class GradientRowCell: UITableViewCell {
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                backgroundColor = .clear
                textLabel?.text = gradient.title
                
                let gradColors = gradient.colors.map({ (stringDict) -> String? in
                    return stringDict.hex
                }).compactMap({ $0 }).map({ $0.uppercased() }).joined(separator: ", ")
                
                detailTextLabel?.text = gradColors
                detailTextLabel?.textColor = .black
                textLabel?.textColor = .black
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func applyShadow() {
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.6
    }
}

final class SelectGradientViewController: UIViewController {
    var gradients: [GradientColor]?
    let tableView = UITableView()
    let header = UIView()
    let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.width - 75))
    let colorOne = UIView()
    let colorTwo = UIView()
    let colorThree = UIView()
    let colorFour = UIView()
    let indicator = UIImageView(image: #imageLiteral(resourceName: "pulley_indicator"))
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                setGradient(gradient)
            }
        }
    }
    
    let backgroundView: UIView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    func cellFactory(_ gradient: GradientColor) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuse")
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.textLabel?.text = gradient.title
        
//        let gradColors = gradient.colors.map({ (stringDict) -> String? in
//            return stringDict.keys.first
//        }).flatMap({ $0 }).map({ $0.uppercased() }).joined(separator: ", ")
        
//        cell.detailTextLabel?.text = gradColors
        cell.detailTextLabel?.textColor = .white
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func setGradient(_ gradient: GradientColor) {
        [colorOne, colorTwo, colorThree, colorFour].forEach { $0.isHidden = true }
        gradient.colors.enumerated().forEach { offset, color in
            switch offset {
            case 0: colorOne.backgroundColor = color.color
            colorOne.isHidden = false
            case 1: colorTwo.backgroundColor = color.color
            colorTwo.isHidden = false
            case 2: colorThree.backgroundColor = color.color
            colorThree.isHidden = false
            case 3: colorFour.backgroundColor = color.color
            colorFour.isHidden = false
            default: return
            }
        }
        
        colorPicker.adjustToColor(gradient.colors.first?.color ?? .black)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableView.backgroundView = backgroundView
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .prominent))
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(GradientRowCell.self, forCellReuseIdentifier: String(describing: GradientRowCell.self))
        
        
        
        header.addSubview(colorPicker)
        header.backgroundColor = .clear
        
        colorPicker.stroke = 10
        colorPicker.delegate = self
        colorPicker.sizeAnchors == CGSize(width: 300, height: 300)
        colorPicker.topAnchor == header.topAnchor
        colorPicker.centerXAnchor == header.centerXAnchor
        colorPicker.bottomAnchor == header.bottomAnchor
        
        
        let stack = UIStackView(arrangedSubviews: [header, tableView])
        stack.axis = .vertical
        view.addSubview(stack)
        view.backgroundColor = .clear
        stack.edgeAnchors == view.edgeAnchors
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 114, height: 18))
        imageView.image = #imageLiteral(resourceName: "uigradients")
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.barTintColor = .black
        
        let navItemImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        navItemImageView.image = #imageLiteral(resourceName: "close_menu").withRenderingMode(.alwaysTemplate)
        navItemImageView.contentMode = .scaleAspectFit
        navItemImageView.tintColor = .white
        navItemImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
        [colorOne, colorTwo, colorThree, colorFour].forEach { colorView in
            header.addSubview(colorView)
            colorView.sizeAnchors == CGSize(width: 60, height: 60)
            colorView.layer.cornerRadius = 8
            colorView.applyShadow()
        }
        
        colorOne.leadingAnchor == header.leadingAnchor + 12
        colorOne.topAnchor == header.topAnchor + 12
        
        colorTwo.trailingAnchor == header.trailingAnchor - 12
        colorTwo.topAnchor == header.topAnchor + 12
        
        colorThree.leadingAnchor == header.leadingAnchor + 12
        colorThree.bottomAnchor == header.bottomAnchor - 12
        
        colorFour.trailingAnchor == header.trailingAnchor - 12
        colorFour.bottomAnchor == header.bottomAnchor - 12
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navItemImageView)
        
        _ = GradientHelper.produceGradients { [weak self] (gradients) in
            guard let strongSelf = self else { return }
            strongSelf.gradients = gradients
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectGradientViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presentingViewController?.childViewControllers.first as? RootPageViewController else { return }
        dismiss(animated: true) { 
            presenter.scrollToPage(.at(index: indexPath.row), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let gradients = gradients,
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GradientRowCell.self), for: indexPath) as? GradientRowCell else {
                return UITableViewCell()
        }
        cell.gradient = gradients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let gradients = gradients else { return 0 }
        return gradients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


extension SelectGradientViewController: PulleyDrawerViewControllerDelegate {
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [
            .collapsed,
            .partiallyRevealed,
            .open
        ]
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 100
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 300 + bottomSafeArea
    }
}

extension SelectGradientViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
    }
}
