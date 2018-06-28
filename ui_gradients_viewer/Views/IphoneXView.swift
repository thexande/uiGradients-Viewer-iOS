import UIKit
import Anchorage
import GradientView

final class IPhoneXView: UIView {
    let border = UIView()
    let notch = UIView()
    let background = GradientView()
    let clock = UILabel()
    let lock = UIImageView(image: UIImage(named: "ic_lock"))
    let lockContainer = UIView()
    let sub = UILabel()
    
    var gradient: GradientColor? {
        didSet {
            background.colors = gradient?.colors.map { $0.color } ?? []
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(background)
        background.edgeAnchors == edgeAnchors
        background.clipsToBounds = true
        background.layer.cornerRadius = 40
        
        addSubview(border)
        border.edgeAnchors == edgeAnchors
        border.layer.borderColor = UIColor.black.cgColor
        border.layer.borderWidth = 8
        border.layer.cornerRadius = 40
        border.clipsToBounds = true
        border.clipsToBounds = true
        border.layer.cornerRadius = 40
        
        background.addSubview(notch)
        notch.backgroundColor = .black
        notch.heightAnchor == 40
        notch.widthAnchor == 130
        notch.centerXAnchor == centerXAnchor
        notch.centerYAnchor == topAnchor
        notch.layer.cornerRadius = 20
        
        lockContainer.addSubview(lock)
        lock.verticalAnchors == lockContainer.verticalAnchors
        lock.centerXAnchor == lockContainer.centerXAnchor
        
        lock.sizeAnchors == CGSize(width: 20, height: 20)
        lock.contentMode = .scaleAspectFit
        
        let stack = UIStackView(arrangedSubviews: [lockContainer, clock, sub])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.topAnchor == background.topAnchor + 36
        stack.centerXAnchor == centerXAnchor
        
        clock.font = UIFont.systemFont(ofSize: 46, weight: .medium)
        clock.textColor = .white
        clock.text = "12:24"
        clock.textAlignment = .center
        
        sub.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        sub.text = "Tuesday, September 13"
        sub.textColor = .white
        sub.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
