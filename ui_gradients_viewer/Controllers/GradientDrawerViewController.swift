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




final class GradientCardView: UIView {
    let gradientCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let cardSection = GradientCardSectionController()
    
    var gradients: [GradientColor] = [] {
        didSet {
            cardSection.gradients = gradients
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientCardCollectionView.delegate = cardSection
        gradientCardCollectionView.dataSource = cardSection
        cardSection.registerReusableTypes(collectionView: gradientCardCollectionView)
        gradientCardCollectionView.backgroundColor = .clear
        addSubview(gradientCardCollectionView)
        gradientCardCollectionView.edgeAnchors == edgeAnchors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





final class GradientDrawerViewController: UIViewController {
    let cardView = GradientCardView()
    let header = DrawerHeaderView()
    let pager = PagerView()
    let customize = CustomizeGradientView()
    let export = ExportView()
    let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    var gradients: [GradientColor] = [] {
        didSet {
            cardView.cardSection.gradients = gradients
        }
    }
    
    var gradient: GradientColor? {
        didSet {
            header.gradient = gradient
            customize.gradient = gradient
            export.gradient = gradient
        }
    }
    
    weak var dispatch: GradientActionDispatching? {
        didSet {
            cardView.cardSection.dispatch = dispatch
            customize.dispatch = dispatch
            header.dispatch = dispatch
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        
        pager.pagerDatasource = self
        pager.pagerDelegate = self
        pager.collection.reloadData()
        
        header.colorCollection.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:))))
        pulleyViewController?.topInset = 100
        
        let stack = UIStackView(arrangedSubviews: [header, pager])
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
                strongSelf.cardView.gradientCardCollectionView.reloadData()
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


extension GradientDrawerViewController: PulleyDrawerViewControllerDelegate {
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [
            .collapsed,
            .partiallyRevealed,
            .open
        ]
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return bottomSafeArea + 80
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 310 + bottomSafeArea
    }
}

extension GradientDrawerViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
    }
}


extension GradientDrawerViewController: PagerDelegate, PagerDatasource {
    func numberOfPages() -> Int {
        return 3
    }
    
    func pageForItem(at indexPath: IndexPath) -> UIView {
        switch indexPath.row {
        case 0: return customize
        case 1: return cardView
        default: return export
        }
    }
}
