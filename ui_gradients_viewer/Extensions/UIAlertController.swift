import UIKit

extension UIAlertAction {
    static func cancel() -> UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}

extension UIAlertController {
    static func confirmationAlert(confirmationTitle: String, confirmationMessage: String) -> UIAlertController {
        let alertController = UIAlertController(title: confirmationTitle, message: confirmationMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
}
