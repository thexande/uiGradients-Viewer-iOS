import UIKit
import Anchorage
import GradientView

class GradientDetailViewController: UIViewController {
    let header = UIView()
    let save = UIButton()
    let gradientView = GradientView()
    weak var dispatch: GradientActionDispatching?
    
    var gradientColor: GradientColor? {
        didSet {
            if let gradientColor = gradientColor {
                configureGradient(gradientColor)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let status = gradientColor?.colors.first?.color.isLight, status {
            return .default
        } else {
            return .lightContent
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(pressedBack), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "back_button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(_ gradient: GradientColor) {
        super.init(nibName: nil, bundle: nil)
        gradientColor = gradient
        configureGradient(gradient)
        
        view.insertSubview(gradientView, at: 0)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(titleLabel)
        header.addSubview(subTitleLabel)
        
        view.addSubview(header)
        header.horizontalAnchors == view.horizontalAnchors
        header.topAnchor == view.topAnchor
        header.bottomAnchor == subTitleLabel.bottomAnchor + 18
        
        self.navigationController?.navigationBar.barTintColor = .black
        
        let viewsDict = ["title":titleLabel, "grad":gradientView, "sub_title":subTitleLabel]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[title]-12-[sub_title]", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[title]-12-|", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[sub_title]-12-|", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[grad]|", options: [], metrics: nil, views: viewsDict))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[grad]|", options: [], metrics: nil, views: viewsDict))
        
        
        titleLabel.topAnchor == view.safeAreaLayoutGuide.topAnchor + 12
    }
    
    func produceBackgroundSnapshot() {
        dispatch?.dispatch(.saveGradient(gradientView.getSnapshotImage()))
    }
    
    @objc func pressedBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureGradient(_ gradient: GradientColor) {
        self.gradientView.colors = gradient.colors.map { $0.color }
        titleLabel.text = gradient.title.uppercased()
        subTitleLabel.text = gradient.colors.map({ (stringDict) -> String? in
            return stringDict.hex
        }).compactMap({ $0 }).map({ $0.uppercased() }).joined(separator: ", ")
        setNeedsStatusBarAppearanceUpdate()
        
        gradientView.locations = [CGFloat(gradient.position)]
        
        switch gradient.format {
        case .horizontal: gradientView.direction = .horizontal
        case .vertical: gradientView.direction = .vertical
        default: return
        }
        
        [titleLabel, subTitleLabel].forEach { label in
            label.textColor = ((gradient.colors.first?.color.isLight ?? false) ? .black : .white)
        }  
    }
}
