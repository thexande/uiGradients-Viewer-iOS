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





final class SelectGradientViewController: UIViewController {
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


extension SelectGradientViewController: PulleyDrawerViewControllerDelegate {
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

extension SelectGradientViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
    }
}


extension SelectGradientViewController: PagerDelegate, PagerDatasource {
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

final class IPhoneXView: UIView {
    let border = UIView()
    let notch = UIView()
    let background = GradientView()
    let clock = UILabel()
    let lock = UIImageView(image: UIImage(named: "ic_lock"))
    let lockContainer = UIView()
    let sub = UILabel()
    
    var gradient: GradientColor? {
        didSet {
            background.colors = gradient?.colors.map { $0.color } ?? []
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(background)
        background.edgeAnchors == edgeAnchors
        background.clipsToBounds = true
        background.layer.cornerRadius = 40
        
        addSubview(border)
        border.edgeAnchors == edgeAnchors
        border.layer.borderColor = UIColor.black.cgColor
        border.layer.borderWidth = 8
        border.layer.cornerRadius = 40
        border.clipsToBounds = true
        border.clipsToBounds = true
        border.layer.cornerRadius = 40
        
        background.addSubview(notch)
        notch.backgroundColor = .black
        notch.heightAnchor == 40
        notch.widthAnchor == 130
        notch.centerXAnchor == centerXAnchor
        notch.centerYAnchor == topAnchor
        notch.layer.cornerRadius = 20
        
        lockContainer.addSubview(lock)
        lock.verticalAnchors == lockContainer.verticalAnchors
        lock.centerXAnchor == lockContainer.centerXAnchor
        
        lock.sizeAnchors == CGSize(width: 20, height: 20)
        lock.contentMode = .scaleAspectFit
        
        let stack = UIStackView(arrangedSubviews: [lockContainer, clock, sub])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.topAnchor == background.topAnchor + 36
        stack.centerXAnchor == centerXAnchor
        
        clock.font = UIFont.systemFont(ofSize: 46, weight: .medium)
        clock.textColor = .white
        clock.text = "12:24"
        clock.textAlignment = .center
        
        sub.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        sub.text = "Tuesday, September 13"
        sub.textColor = .white
        sub.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ExportView: UIView {
    let iphone = IPhoneXView()
    let export = UIButton()
    let buttonGradient = GradientView()
    
    
    var gradient: GradientColor? {
        didSet {
            iphone.gradient = gradient
            buttonGradient.colors = gradient?.colors.map { $0.color } ?? []
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iphone)
        addSubview(export)
        export.addSubview(buttonGradient)
        
        iphone.applyShadow()
        iphone.horizontalAnchors == horizontalAnchors + 60
        iphone.topAnchor == export.bottomAnchor + 36
        iphone.bottomAnchor == bottomAnchor + 40
        
        export.layer.cornerRadius = 8
        export.applyShadow()
        export.titleLabel?.textColor = .white
        export.backgroundColor = .black
        export.horizontalAnchors == horizontalAnchors + 36
        export.heightAnchor == 36
        export.topAnchor == topAnchor + 18
        export.setTitle("Export", for: .normal)
        export.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        buttonGradient.edgeAnchors == export.edgeAnchors
        buttonGradient.direction = .horizontal
        buttonGradient.layer.cornerRadius = 8
        buttonGradient.clipsToBounds = true
        
        
        
    }
    
    override func layoutSubviews() {
//        export.setBackgroundImage(buttonGradient.getSnapshotImage(), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
