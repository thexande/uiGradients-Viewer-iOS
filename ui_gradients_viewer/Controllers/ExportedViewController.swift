import UIKit
import Anchorage

final class ExportedViewController: UIViewController {
     let confettiView = SAConfettiView(properties: ConfettiCardProperties(colorsNodes: true, colors: ConfettiCardProperties.defaultColors, type: .confetti))
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(confettiView)
        confettiView.edgeAnchors == view.edgeAnchors
    }
}
