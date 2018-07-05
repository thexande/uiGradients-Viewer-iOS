import UIKit
import Anchorage

final class SegmentedView: UIView {
    let titleLabel = UILabel()
    let segment = UISegmentedControl(items: ["Horizontal", "Vertical", "Radial"])
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var tint: UIColor = .white {
        didSet {
            segment.tintColor = tint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.numberOfLines = 0
        let stack = UIStackView(arrangedSubviews: [titleLabel, segment])
        stack.spacing = 12
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
        titleLabel.widthAnchor == segment.widthAnchor / 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
