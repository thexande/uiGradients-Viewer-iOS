import UIKit
import Anchorage
import GradientView

final class ColorPickerCollectionCell: UICollectionViewCell {
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let title = UILabel()
    let clipping = UIView()
    let gradientView = GradientView()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                UIView.animate(withDuration: 0.4) {
                    self.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
                }
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    var color: GradientColor.Color? {
        didSet {
            if let color = color {
                title.text = color.hex.uppercased()
                clipping.backgroundColor = color.color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.font = UIFont.systemFont(ofSize: 14)
        title.numberOfLines = 0
        title.textAlignment = .center
        
        blur.contentView.addSubview(title)
        clipping.addSubview(blur)
        clipping.layer.cornerRadius = 8
        clipping.clipsToBounds = true
        
        title.edgeAnchors == blur.edgeAnchors + UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
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
