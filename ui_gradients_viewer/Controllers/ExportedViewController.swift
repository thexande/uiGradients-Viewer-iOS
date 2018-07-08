import UIKit
import Anchorage
import GradientView

final class ExportedViewController: UIViewController {
     let confettiView = SAConfettiView(properties: ConfettiCardProperties(colorsNodes: true, colors: ConfettiCardProperties.defaultColors, type: .confetti))
    let iphone = IPhoneXView()
    let party = UILabel()
    let header = UILabel()
    let woot = UILabel()
    let donate = DonateView()
    let buttonGradient = GradientView()
    let buttonTitle = UILabel()
    
    var gradient: GradientColor? {
        didSet {
            iphone.gradient = gradient
            let colors = gradient?.colors.map { $0.color } ?? []
            buttonGradient.colors = colors
            if colors.first?.isLight ?? false {
                buttonTitle.textColor = .black
            } else {
                buttonTitle.textColor = .white
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    weak var dispatcher: GradientActionDispatching? {
        didSet {
            donate.dispatcher = dispatcher
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overCurrentContext
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
        buttonGradient.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapExport)))
        buttonGradient.layer.shadowRadius = 4
        buttonGradient.layer.shadowColor = UIColor.white.cgColor
        buttonGradient.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonGradient.layer.shadowOpacity = 0.3
        buttonGradient.addSubview(buttonTitle)
        buttonTitle.edgeAnchors == buttonGradient.edgeAnchors + UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        buttonTitle.centerYAnchor == buttonGradient.centerYAnchor
        buttonTitle.text = "No thanks, just let me have the background for free."
        buttonTitle.textColor = .white
        buttonTitle.numberOfLines = 0
        buttonTitle.textAlignment = .center
        
        confettiView.startConfetti()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0.5, options: [.autoreverse, .repeat], animations: {
            self.party.transform = .identity
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        party.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    @objc private func didTapExport() {
        dispatcher?.dispatch(.exportDismiss)
    }
}
