import UIKit
import Anchorage

final class Slider: UIView {
    let titleLabel = UILabel()
    let slider = UISlider()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var tint: UIColor? {
        didSet {
            slider.tintColor = tint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.numberOfLines = 0
        let stack = UIStackView(arrangedSubviews: [titleLabel, slider])
        stack.spacing = 12
        titleLabel.widthAnchor == slider.widthAnchor / 3
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


