import UIKit
import Anchorage
import GradientView
import GoogleMobileAds

final class ExportView: UIView {
    let iphone = IPhoneXView()
    let export = UIButton()
    let buttonGradient = GradientView()
    let banner = GADBannerView(adSize: kGADAdSizeLargeBanner)
    weak var dispatch: GradientActionDispatching?
    
    var gradient: GradientColor? {
        didSet {
            iphone.gradient = gradient
            buttonGradient.colors = gradient?.colors.map { $0.color } ?? []
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iphone)
        addSubview(export)
        addSubview(banner)
        export.addSubview(buttonGradient)
        
        iphone.applyShadow()
        iphone.horizontalAnchors == horizontalAnchors + 60
        iphone.topAnchor == export.bottomAnchor + 36
        iphone.bottomAnchor == bottomAnchor + 40
        
        banner.topAnchor == topAnchor + 6
        banner.centerXAnchor == centerXAnchor
        
        export.layer.cornerRadius = 8
        export.applyShadow()
        export.titleLabel?.textColor = .white
        export.backgroundColor = .black
        export.horizontalAnchors == horizontalAnchors + 36
        export.heightAnchor == 36
        export.topAnchor == banner.bottomAnchor + 18
        export.setTitle("Export", for: .normal)
        export.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        buttonGradient.edgeAnchors == export.edgeAnchors
        buttonGradient.direction = .horizontal
        buttonGradient.layer.cornerRadius = 8
        buttonGradient.clipsToBounds = true
        
        buttonGradient.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapExport)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapExport() {
        dispatch?.dispatch(.exportCurrentGradient)
    }
}
