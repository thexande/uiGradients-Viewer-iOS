import UIKit
import Anchorage

final class CustomizeGradientView: UIView {
    weak var dispatch: GradientActionDispatching?
    let position = Slider()
    let radius = Slider()
    let gradientSegmented = SegmentedView()
    let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                setGradient(gradient)
            }
        }
    }
    
    func setGradient(_ gradient: GradientColor) {
        position.tint = gradient.colors.first?.color ?? .black
        gradientSegmented.tint = gradient.colors.first?.color ?? .black
        radius.tint = gradient.colors.first?.color ?? .black
        
        if let first = gradient.colors.first?.color, first != colorPicker.currentColor {
            colorPicker.adjustToColor(first)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientSegmented.title = "type".capitalized
        position.title = "position".capitalized
        radius.title = "radius".capitalized        
        let stack = UIStackView(arrangedSubviews: [position, gradientSegmented, radius])
        stack.spacing = 18
        stack.axis = .vertical
        addSubview(stack)
        stack.horizontalAnchors == horizontalAnchors + 18
        stack.topAnchor == topAnchor + 18
        addSubview(colorPicker)
        colorPicker.stroke = 10
        colorPicker.sizeAnchors == CGSize(width: 300, height: 300)
        colorPicker.centerXAnchor == centerXAnchor
        colorPicker.topAnchor == stack.bottomAnchor + 18
        colorPicker.bottomAnchor <= bottomAnchor ~ .low
//        colorPicker.shadeSlider.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
