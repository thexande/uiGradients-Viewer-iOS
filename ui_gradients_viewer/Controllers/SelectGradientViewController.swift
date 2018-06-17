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
import GradientView

extension UIView {
    func applyShadow() {
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
    }
}

final class DrawerHeaderView: UIView {
    let indicator = UIImageView(image: #imageLiteral(resourceName: "pulley_indicator"))
    let colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.width - 75))
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                setGradient(gradient)
            }
        }
    }
    
    func setGradient(_ gradient: GradientColor) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(colorPicker)
        colorPicker.stroke = 10
        colorPicker.sizeAnchors == CGSize(width: 300, height: 300)
        colorPicker.topAnchor == topAnchor
        colorPicker.centerXAnchor == centerXAnchor
        colorPicker.bottomAnchor == bottomAnchor
        
        addSubview(indicator)
        indicator.centerXAnchor == centerXAnchor
        indicator.topAnchor == topAnchor + 6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SelectGradientViewController: UIViewController {
    weak var dispatch: GradientActionDispatching?
    let cardSection = GradientCardSectionController()
    let gradientCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let header = DrawerHeaderView()
    
    let colorOne = UIView()
    let colorTwo = UIView()
    let colorThree = UIView()
    let colorFour = UIView()
    
    
    var gradients: [GradientColor] = [] {
        didSet {
            cardSection.gradients = gradients
        }
    }
    
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
        
        header.colorPicker.adjustToColor(gradient.colors.first?.color ?? .black)
    }
    
    func configureColorTiles() {
        colorOne.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorOneSelected)))
        colorTwo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorTwoSelected)))
        colorThree.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorThreeSelected)))
        colorFour.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(colorFourSelected)))
    }
    
    @objc func colorOneSelected() {
        UIView.animate(withDuration: 0.3) {
            self.colorOne.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    @objc func colorTwoSelected() {
        
    }
    
    @objc func colorThreeSelected() {
        
    }
    
    @objc func colorFourSelected() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColorTiles()
        view.backgroundColor = .clear
        
        header.colorPicker.delegate = self
        pulleyViewController?.topInset = 100
        
        gradientCardCollectionView.delegate = cardSection
        gradientCardCollectionView.dataSource = cardSection
        cardSection.registerReusableTypes(collectionView: gradientCardCollectionView)
        gradientCardCollectionView.backgroundColor = .clear
        
        
        let stack = UIStackView(arrangedSubviews: [header, gradientCardCollectionView])
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
                strongSelf.gradientCardCollectionView.reloadData()
            }
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
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
