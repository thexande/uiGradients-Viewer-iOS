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










final class SelectGradientViewController: UIViewController {
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
    
    weak var dispatch: GradientActionDispatching? {
        didSet {
            cardSection.dispatch = dispatch
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
        return bottomSafeArea + 120
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 270 + bottomSafeArea
    }
}

extension SelectGradientViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
    }
}
