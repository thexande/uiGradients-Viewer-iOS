import UIKit
import Anchorage
import GradientView

final class DrawerHeaderView: UIView {
    let indicator = UIView()
    let colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorSection = ColorPickerCollectionSectionController()
    let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let segmented = UISegmentedControl(items: ["Customize", "Popular", "Export"])
    let slider = Slider()
    let radius = Slider()
    let gradientSegmented = SegmentedView()
    
    
    
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
        segmented.tintColor = gradient.colors.first?.color ?? .black
        slider.tint = gradient.colors.first?.color ?? .black
        gradientSegmented.tint = gradient.colors.first?.color ?? .black
        radius.tint = gradient.colors.first?.color ?? .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(segmented)
        
        addSubview(colorCollection)
        colorCollection.clipsToBounds = false
        colorCollection.horizontalAnchors == horizontalAnchors + 18
        colorCollection.topAnchor == topAnchor + 18
        colorCollection.heightAnchor == 64
        colorCollection.delegate = colorSection
        colorCollection.dataSource = colorSection
        colorCollection.backgroundColor = .clear
        colorSection.registerReusableTypes(collectionView: colorCollection)
        
        gradientSegmented.title = "type".capitalized
        slider.title = "position".capitalized
        radius.title = "radius".capitalized
        
        
        let controlStack = UIStackView(arrangedSubviews: [segmented, slider, gradientSegmented, radius])
        controlStack.spacing = 18
        controlStack.axis = .vertical
        addSubview(controlStack)
        
        controlStack.horizontalAnchors == colorCollection.horizontalAnchors
        controlStack.topAnchor == colorCollection.bottomAnchor + 18
        segmented.selectedSegmentIndex = 0
        
        
        if let layout = colorCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        addSubview(colorPicker)
        colorPicker.stroke = 10
        colorPicker.sizeAnchors == CGSize(width: 300, height: 300)
        colorPicker.topAnchor == controlStack.bottomAnchor + 18
        colorPicker.centerXAnchor == centerXAnchor
        colorPicker.bottomAnchor == bottomAnchor
        
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

