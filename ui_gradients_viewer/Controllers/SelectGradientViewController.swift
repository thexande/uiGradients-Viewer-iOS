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

class GradientCollectionCell: UICollectionViewCell {
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let title = UILabel()
    let sub = UILabel()
    let clipping = UIView()
    let gradientView = GradientView()
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                backgroundColor = .clear
                title.text = gradient.title
                
                let gradColors = gradient.colors.map({ (stringDict) -> String? in
                    return stringDict.hex
                }).compactMap({ $0 }).map({ $0.uppercased() }).joined(separator: ", ")
                sub.text = gradColors
                
                gradientView.colors = gradient.colors.map { $0.color }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientView.direction = .horizontal
        clipping.insertSubview(gradientView, at: 0)
        gradientView.edgeAnchors == clipping.edgeAnchors
        
        let stack = UIStackView(arrangedSubviews: [title, sub])
        stack.spacing = 2
        stack.axis = .vertical
        
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 0
        sub.font = UIFont.systemFont(ofSize: 12)
        sub.numberOfLines = 0
        
        blur.contentView.addSubview(stack)
        clipping.addSubview(blur)
        clipping.layer.cornerRadius = 8
        clipping.clipsToBounds = true
        
        stack.edgeAnchors == blur.edgeAnchors + UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        blur.bottomAnchor == clipping.bottomAnchor
        blur.horizontalAnchors == clipping.horizontalAnchors
        
        contentView.addSubview(clipping)
        contentView.applyShadow()
        clipping.edgeAnchors == contentView.edgeAnchors
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
        layer.shadowOpacity = 0.3
    }
}

final class SelectGradientViewController: UIViewController {
    var gradients: [GradientColor]?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let header = UIView()
    let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.width - 75))
    let colorOne = UIView()
    let colorTwo = UIView()
    let colorThree = UIView()
    let colorFour = UIView()
    let indicator = UIImageView(image: #imageLiteral(resourceName: "pulley_indicator"))
    weak var dispatch: GradientActionDispatching?
    
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
        
        colorPicker.adjustToColor(gradient.colors.first?.color ?? .black)
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
        
        pulleyViewController?.topInset = 100
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(GradientCollectionCell.self, forCellWithReuseIdentifier: String(describing: GradientCollectionCell.self))
        
        header.addSubview(colorPicker)
        header.backgroundColor = .clear
        
        colorPicker.stroke = 10
        colorPicker.delegate = self
        colorPicker.sizeAnchors == CGSize(width: 300, height: 300)
        colorPicker.topAnchor == header.topAnchor
        colorPicker.centerXAnchor == header.centerXAnchor
        colorPicker.bottomAnchor == header.bottomAnchor
        
        header.addSubview(indicator)
        indicator.centerXAnchor == header.centerXAnchor
        indicator.topAnchor == header.topAnchor + 6
        
        let stack = UIStackView(arrangedSubviews: [header, collectionView])
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
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectGradientViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gradients?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GradientCollectionCell.self), for: indexPath) as? GradientCollectionCell else {
            return UICollectionViewCell()
        }
        
        if let gradients = gradients {
            cell.gradient = gradients[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 36) / 2, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dispatch?.dispatch(.selectedGradientFromDrawer(indexPath.row))
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
