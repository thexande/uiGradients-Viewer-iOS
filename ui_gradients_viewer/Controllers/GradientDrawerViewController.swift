import UIKit
import Anchorage
import Pulley
import GradientView

final class GradientDrawerViewController: UIViewController {
    let cardView = GradientCardView()
    let header = DrawerHeaderView()
    let pager = PagerView()
    let customize = CustomizeGradientView()
    let export = ExportView()
    let light = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let dark = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    var gradients: [GradientColor] = [] {
        didSet {
            cardView.cardSection.gradients = gradients
            
        }
    }
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                update(gradient)
            }
        }
    }
    
    private func update(_ gradient: GradientColor) {
        header.gradient = gradient
        customize.gradient = gradient
        export.gradient = gradient
        
        guard let pulley = parent as? PulleyViewController else { return }
        
        if gradient.colors.first?.color.isLight ?? false {
            UIView.animate(withDuration: 0.3) {
                pulley.drawerBackgroundVisualEffectView?.effect = UIBlurEffect(style: .dark)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                pulley.drawerBackgroundVisualEffectView?.effect = UIBlurEffect(style: .light)
            }
        }
    }
    
    weak var dispatch: GradientActionDispatching? {
        didSet {
            cardView.cardSection.dispatch = dispatch
            customize.dispatch = dispatch
            header.dispatch = dispatch
            export.dispatch = dispatch
            header.colorSection.dispatcher = dispatch
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        customize.colorPicker.delegate = self
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
        guard
            let selectedIndex = header.colorCollection.indexPathsForSelectedItems?.first?.row,
            let gradient = gradient else {
                return
        }
        dispatch?.dispatch(.colorChange(identifier: gradient.colors[selectedIndex].identifier, newColor: color))
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
