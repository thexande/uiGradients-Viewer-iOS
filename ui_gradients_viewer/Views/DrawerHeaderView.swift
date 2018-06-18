import UIKit
import Anchorage
import GradientView
import ChromaColorPicker

final class DrawerHeaderView: UIView {
    let indicator = UIView()
    let colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorSection = ColorPickerCollectionSectionController()
    let segmented = UISegmentedControl(items: ["Customize", "Popular", "Export"])
    weak var dispatch: GradientActionDispatching?
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                setGradient(gradient)
            }
        }
    }
    
    func setGradient(_ gradient: GradientColor) {
        colorSection.items = gradient.colors
        colorCollection.reloadData()
        segmented.tintColor = gradient.colors.first?.color ?? .black
    }
    
    @objc func segmentChanged(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0: dispatch?.dispatch(.drawerContextChange(.customize))
        case 1: dispatch?.dispatch(.drawerContextChange(.popular))
        case 2: dispatch?.dispatch(.drawerContextChange(.export))
        default: return
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let controlStack = UIStackView(arrangedSubviews: [colorCollection, segmented])
        controlStack.spacing = 36
        controlStack.axis = .vertical
        addSubview(controlStack)
        
        colorCollection.clipsToBounds = false
        colorCollection.heightAnchor == 64
        colorCollection.delegate = colorSection
        colorCollection.dataSource = colorSection
        colorCollection.backgroundColor = .clear
        colorSection.registerReusableTypes(collectionView: colorCollection)
        controlStack.edgeAnchors == edgeAnchors + UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        
        if let layout = colorCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        addSubview(indicator)
        indicator.centerXAnchor == centerXAnchor
        indicator.topAnchor == topAnchor + 6
        indicator.backgroundColor = UIColor.darkGray
        indicator.heightAnchor == 4
        indicator.widthAnchor == 42
        indicator.layer.cornerRadius = 2
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

