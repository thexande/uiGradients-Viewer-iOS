import UIKit
import Anchorage

final class SwitchView: UIView {
    let titleLabel = UILabel()
    let `switch` = UISwitch()
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var tint: UIColor? {
        didSet {
            `switch`.tintColor = tint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [titleLabel, `switch`])
        stack.spacing = 12
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
