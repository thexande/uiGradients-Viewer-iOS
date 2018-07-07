import UIKit
import Anchorage
import QRCode

final class QRDispalyViewController: UIViewController {
    weak var dispatcher: GradientActionDispatching?
    let image = UIImageView()
    
    var currency: GradientAction.Currency? {
        didSet {
            if let currency = currency {
                address = currency.address
                title = "Donate \(currency.title)"
            }
        }
    }
    
    public var address: String? {
        didSet {
            if let address = address {
                let qrCode = QRCode(address)
                image.image = qrCode?.image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(image)
        image.widthAnchor == view.widthAnchor - 64
        image.heightAnchor == image.widthAnchor
        image.centerAnchors == view.centerAnchors
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(done))
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
}
