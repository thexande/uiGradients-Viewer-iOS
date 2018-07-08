import UIKit
import Anchorage

final class DonateView: UIView {
    weak var dispatcher: GradientActionDispatching?
    let btc = UIButton()
    let eth = UIButton()
    let ltc = UIButton()
    let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        btc.setImage(UIImage(named: "btc"), for: .normal)
        btc.contentMode = .scaleAspectFit
        
        btc.addAction { [weak self] in
            self?.dispatcher?.dispatch(.presentDonationOptions(.btc))
        }
        
        eth.setImage(UIImage(named: "eth"), for: .normal)
        eth.contentMode = .scaleAspectFit
        
        eth.addAction { [weak self] in
            self?.dispatcher?.dispatch(.presentDonationOptions(.eth))
        }
        
        ltc.setImage(UIImage(named: "litecoin"), for: .normal)
        ltc.contentMode = .scaleAspectFit
        
        ltc.addAction { [weak self] in
            self?.dispatcher?.dispatch(.presentDonationOptions(.ltc))
        }
        
        [btc, eth, ltc].forEach { button in
            let container = UIView()
            container.backgroundColor = .lightGray
            container.layer.cornerRadius = 8
            container.addSubview(button)
            button.edgeAnchors == container.edgeAnchors + UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            container.widthAnchor == container.heightAnchor
            stack.addArrangedSubview(container)
        }
        
        stack.spacing = 12
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.edgeAnchors == edgeAnchors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
