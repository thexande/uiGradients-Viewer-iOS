import UIKit
import Anchorage
import GradientView

final class ColorPickerCollectionCell: UICollectionViewCell {
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let title = UILabel()
    let clipping = UIView()
    let gradientView = GradientView()
    
    var color: GradientColor.Color? {
        didSet {
            if let color = color {
                title.text = color.hex
                clipping.backgroundColor = color.color
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 0
        
        blur.contentView.addSubview(title)
        clipping.addSubview(blur)
        clipping.layer.cornerRadius = 8
        clipping.clipsToBounds = true
        
        title.edgeAnchors == blur.edgeAnchors + UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        blur.bottomAnchor == clipping.bottomAnchor
        blur.horizontalAnchors == clipping.horizontalAnchors
        
        contentView.addSubview(clipping)
        contentView.applyShadow()
        clipping.edgeAnchors == contentView.edgeAnchors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class GradientCollectionCell: UICollectionViewCell {
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let title = UILabel()
    let sub = UILabel()
    let clipping = UIView()
    let gradientView = GradientView()
    
    var gradient: GradientColor? {
        didSet {
            if let gradient = gradient {
                backgroundColor = .clear
                title.text = gradient.title
                
                let gradColors = gradient.colors.map({ (stringDict) -> String? in
                    return stringDict.hex
                }).compactMap({ $0 }).map({ $0.uppercased() }).joined(separator: ", ")
                sub.text = gradColors
                
                gradientView.colors = gradient.colors.map { $0.color }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientView.direction = .horizontal
        clipping.insertSubview(gradientView, at: 0)
        gradientView.edgeAnchors == clipping.edgeAnchors
        
        let stack = UIStackView(arrangedSubviews: [title, sub])
        stack.spacing = 2
        stack.axis = .vertical
        
        title.font = UIFont.systemFont(ofSize: 16)
        title.numberOfLines = 0
        sub.font = UIFont.systemFont(ofSize: 12)
        sub.numberOfLines = 0
        
        blur.contentView.addSubview(stack)
        clipping.addSubview(blur)
        clipping.layer.cornerRadius = 8
        clipping.clipsToBounds = true
        
        stack.edgeAnchors == blur.edgeAnchors + UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        blur.bottomAnchor == clipping.bottomAnchor
        blur.horizontalAnchors == clipping.horizontalAnchors
        
        contentView.addSubview(clipping)
        contentView.applyShadow()
        clipping.edgeAnchors == contentView.edgeAnchors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
