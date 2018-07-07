import UIKit
import Anchorage
import QRCode

final class QRDispalyViewController: UIViewController {
    let image = UIImageView()
    
    public var address: String = "" {
        didSet {
            let qrCode = QRCode(address)
            image.image = qrCode?.image
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
