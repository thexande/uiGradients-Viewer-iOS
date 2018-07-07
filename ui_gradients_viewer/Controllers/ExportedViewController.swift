import UIKit
import Anchorage
import GradientView

final class DonateView: UIView {
    let btc = UIButton()
    let eth = UIButton()
    let ltc = UIButton()
    let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        btc.setImage(UIImage(named: "btc"), for: .normal)
        btc.contentMode = .scaleAspectFit
        
        eth.setImage(UIImage(named: "eth"), for: .normal)
        eth.contentMode = .scaleAspectFit
        
        ltc.setImage(UIImage(named: "litecoin"), for: .normal)
        ltc.contentMode = .scaleAspectFit
        
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

final class ExportedViewController: UIViewController {
    weak var dispatcher: GradientActionDispatching?
     let confettiView = SAConfettiView(properties: ConfettiCardProperties(colorsNodes: true, colors: ConfettiCardProperties.defaultColors, type: .confetti))
    let iphone = IPhoneXView()
    let party = UILabel()
    let header = UILabel()
    let woot = UILabel()
    let donate = DonateView()
    let buttonGradient = GradientView()
    
    var gradient: GradientColor? {
        didSet {
            iphone.gradient = gradient
            buttonGradient.colors = gradient?.colors.map { $0.color } ?? []
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.addSubview(confettiView)
        view.addSubview(iphone)
        view.addSubview(party)
        let headerStack = UIStackView(arrangedSubviews: [woot, header])
        headerStack.axis = .vertical
        headerStack.spacing = 12
        view.addSubview(headerStack)
        
        let stack = UIStackView(arrangedSubviews: [headerStack, donate, buttonGradient])
        stack.spacing = 24
        stack.axis = .vertical
        view.addSubview(stack)
        stack.horizontalAnchors == view.horizontalAnchors + 18
        stack.topAnchor == party.bottomAnchor + 18
        
        iphone.frameColor = .white

        confettiView.edgeAnchors == view.edgeAnchors
        
        iphone.horizontalAnchors == view.horizontalAnchors + 80
        iphone.heightAnchor == iphone.widthAnchor * 1.992
        
        iphone.centerXAnchor == view.centerXAnchor
        iphone.topAnchor == stack.bottomAnchor + 42
        
        header.text = "Your gradient background has been saved to your camera roll. \n\n If you enjoy using this free app, feel free to send some crypto my way! 💸"
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 20)
        header.textColor = .white
        header.numberOfLines = 0
        
        party.text = "🎉"
        party.font = UIFont.systemFont(ofSize: 60)
        party.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        party.topAnchor == view.safeAreaLayoutGuide.topAnchor + 12
        party.centerXAnchor == view.centerXAnchor
        
        woot.textColor = .white
        woot.centerXAnchor == view.centerXAnchor
        woot.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        woot.textAlignment = .center
        woot.text = "Woot!"
        
        buttonGradient.direction = .horizontal
        buttonGradient.layer.cornerRadius = 8
        buttonGradient.clipsToBounds = true
        buttonGradient.heightAnchor == 42
        buttonGradient.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapExport)))
        buttonGradient.layer.shadowRadius = 4
        buttonGradient.layer.shadowColor = UIColor.white.cgColor
        buttonGradient.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonGradient.layer.shadowOpacity = 0.3
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0.5, options: [.autoreverse, .repeat], animations: {
            self.party.transform = .identity
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confettiView.startConfetti()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        confettiView.stopConfetti()
    }
    
    @objc private func didTapExport() {
        dispatcher?.dispatch(.exportDismiss)
    }
}
