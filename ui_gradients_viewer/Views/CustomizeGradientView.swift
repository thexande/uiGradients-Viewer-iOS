import UIKit
import Anchorage

final class CustomizeGradientView: UIView {
    weak var dispatch: GradientActionDispatching?
    let position = Slider()
    let radius = Slider()
    let typeSegmented = SegmentedView()
    let colorPicker = ChromaColorPicker()
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                setGradient(gradient)
            }
        }
    }
    
    func setGradient(_ gradient: GradientColor) {
        position.tint = gradient.colors.first?.color ?? .black
        typeSegmented.tint = gradient.colors.first?.color ?? .black
        radius.tint = gradient.colors.first?.color ?? .black
        position.slider.setValue(gradient.position, animated: true)
        
        switch gradient.format {
        case .horizontal: typeSegmented.segment.selectedSegmentIndex = 1
        case .vertical: typeSegmented.segment.selectedSegmentIndex = 0
        default: return
        }
        
        if let first = gradient.colors.first?.color, first != colorPicker.currentColor {
            colorPicker.adjustToColor(first)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        typeSegmented.title = "type".capitalized
        position.title = "position".capitalized
        radius.title = "radius".capitalized        
        let stack = UIStackView(arrangedSubviews: [position, typeSegmented])
        stack.spacing = 12
        stack.axis = .vertical
        addSubview(stack)
        stack.horizontalAnchors == horizontalAnchors + 18
        stack.topAnchor == topAnchor + 12
        addSubview(colorPicker)
        colorPicker.stroke = 10
        colorPicker.centerXAnchor == centerXAnchor
        colorPicker.topAnchor == stack.bottomAnchor
        colorPicker.horizontalAnchors == horizontalAnchors + 36
        colorPicker.heightAnchor == colorPicker.widthAnchor
        
        position.slider.addTarget(self, action: #selector(gradientPositionDidChange(_:)), for: .valueChanged)
        typeSegmented.segment.addTarget(self, action: #selector(gradientFormatDidChange(_:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func gradientFormatDidChange(_ segmented: UISegmentedControl?) {
        switch segmented?.selectedSegmentIndex ?? 0 {
        case 0: dispatch?.dispatch(.gradientFormatDidChange(.vertical))
        case 1: dispatch?.dispatch(.gradientFormatDidChange(.horizontal))
        case 2: dispatch?.dispatch(.gradientFormatDidChange(.radial))
        default: return
        }
    }
    
    @objc private func gradientPositionDidChange(_ position: UISlider?) {
        if let value = position?.value {
            dispatch?.dispatch(.positionChanged(value))
        }
    }
}
