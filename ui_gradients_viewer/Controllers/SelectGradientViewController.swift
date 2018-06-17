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




final class ColorPickerCollectionSectionController: NSObject, CollectionSectionController {
    var items: [GradientColor.Color] = []
    
    func registerReusableTypes(collectionView: UICollectionView) {
        collectionView.register(ColorPickerCollectionCell.self,
                                forCellWithReuseIdentifier: String(describing: ColorPickerCollectionCell.self))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ColorPickerCollectionCell.self),
                                                            for: indexPath) as? ColorPickerCollectionCell else {
            return UICollectionViewCell()
        }
        cell.color = items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (UIScreen.main.bounds.width - 36) / CGFloat(items.count),
            height: collectionView.frame.height
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Starting Index: \(sourceIndexPath.item)")
            print("Ending Index: \(destinationIndexPath.item)")
    }
}

final class DrawerHeaderView: UIView {
    let indicator = UIImageView(image: #imageLiteral(resourceName: "pulley_indicator"))
    let colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorSection = ColorPickerCollectionSectionController()
    let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.width - 75))
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                setGradient(gradient)
            }
        }
    }
    
    func setGradient(_ gradient: GradientColor) {
        colorPicker.adjustToColor(gradient.colors.first?.color ?? .black)
        colorSection.items = gradient.colors
        colorCollection.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(colorCollection)
        colorCollection.horizontalAnchors == horizontalAnchors + 18
        colorCollection.topAnchor == topAnchor + 18
        colorCollection.heightAnchor == 100
        colorCollection.delegate = colorSection
        colorCollection.dataSource = colorSection
        colorCollection.backgroundColor = .clear
        colorSection.registerReusableTypes(collectionView: colorCollection)
        
        if let layout = colorCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        addSubview(colorPicker)
        colorPicker.stroke = 10
        colorPicker.sizeAnchors == CGSize(width: 300, height: 300)
        colorPicker.topAnchor == colorCollection.bottomAnchor + 18
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
    let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    var gradients: [GradientColor] = [] {
        didSet {
            cardSection.gradients = gradients
        }
    }
    
    var gradient: GradientColor? {
        didSet {
            header.gradient = gradient
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        header.colorPicker.delegate = self
        header.colorCollection.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:))))
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
            

    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = header.colorCollection.indexPathForItem(at: gesture.location(in: header.colorCollection)) else {
                break
            }
            header.colorCollection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            header.colorCollection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            header.colorCollection.endInteractiveMovement()
        default:
            header.colorCollection.cancelInteractiveMovement()
        }
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
