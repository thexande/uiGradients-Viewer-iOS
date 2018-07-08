import UIKit
import Pulley
import GradientView
import Photos
import UIKit

enum GradientAction {
    enum DrawerContext {
        case customize
        case popular
        case export
    }
    
    enum Donation {
        case qr(Currency)
        case copyAddress(Currency)
    }
    
    enum Currency {
        case btc
        case eth
        case ltc
        
        var title: String {
            switch self {
            case .btc: return "Bitcoin"
            case .eth: return "Ethereum"
            case .ltc: return "Litecoin"
            }
        }
        
        var address: String {
            return "1F1tAaz5x1HUXrCNLbtMDqcw6o5GNn4xqX"
        }
    }
        
    case selectedGradient(Int)
    case selectedGradientFromDrawer(String)
    case saveGradient(UIImage)
    case drawerContextChange(DrawerContext)
    case colorIndexChange(startingIndex: Int, endingIndex: Int)
    case colorChange(identifier: UUID, newColor: UIColor?)
    case gradientFormatDidChange(GradientColor.Format)
    case exportCurrentGradient
    case positionChanged(Float)
    case formatChanged(GradientColor.Format)
    case exportDismiss
    case donateDismiss
    case donate(Donation)
    case presentDonationOptions(Currency)
    case gradientColorSelected(UUID)
}

protocol GradientActionDispatching: AnyObject { 
    func dispatch(_ action: GradientAction)
}

final class GradientCoordinator {
    let root: PulleyViewController?
    let content: RootPageViewController
    let drawer: GradientDrawerViewController
    let exported = ExportedViewController()
    let donate = QRDispalyViewController()
    var gradients: [GradientColor] = []
    
    var selectedGradient: GradientColor? {
        didSet {
            drawer.gradient = selectedGradient
            guard let gradientDetailViewController = content.gradientVCs.first(where: { vc in
                vc.gradientColor?.title == selectedGradient?.title
            }) else {
                    return
            }
            gradientDetailViewController.gradientColor = selectedGradient
        }
    }
    
    init() {
        let drawer = GradientDrawerViewController()
        self.drawer = drawer
        
        let content = RootPageViewController()
        self.content = content
        
        root = PulleyViewController(contentViewController: self.content, drawerViewController: self.drawer)
        
        self.content.dispatch = self
        self.drawer.dispatch = self
        exported.dispatcher = self
        donate.dispatcher = self          

        
        _ = GradientHelper.produceGradients { [weak self] (gradients) in
            guard let strongSelf = self else { return }
            strongSelf.gradients = gradients
            DispatchQueue.main.async {
                let index = Int.random(from: 0 ..< gradients.count)
                strongSelf.content.startingIndex = index
                strongSelf.content.gradientVCs = gradients.map(GradientDetailViewController.init)
                
                strongSelf.content.gradientVCs.forEach { vc in
                    vc.dispatch = self
                }
                
                
                strongSelf.selectedGradient = gradients[index]
                strongSelf.content.scrollToPage(.at(index: index), animated: true)
            }
        }
    }
    
    private func saveImage(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if success {
                // Saved successfully!
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.exported.gradient = self.selectedGradient
                    self.root?.present(self.exported, animated: true, completion: nil)
                }
            }
            else if let error = error {
                // Save photo failed with error
                let successAlert = UIAlertController(title: "Save Failure", message: "Error saving background to camera roll: \(error.localizedDescription)", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.root?.present(successAlert, animated: true, completion: nil)
                }
            }
            else {
                // Save photo failed with no error
            }
        })
    }
    
    private func drawerContextDidChange(_ context: GradientAction.DrawerContext) {
        switch context {
        case .customize: drawer.pager.collection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        case .export: drawer.pager.collection.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
        case .popular: drawer.pager.collection.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func changeColor(identifier: UUID, newColor: UIColor?) {
        guard
            let gradient = self.selectedGradient,
            let changedColor = gradient.colors.first(where: { $0.identifier == identifier }),
            let index = gradient.colors.index(of: changedColor),
            let newColor = newColor else {
                return
        }
        
        var colors = gradient.colors
        var color = colors.remove(at: index)
        color.color = newColor
        color.hex = newColor.hex
        colors.insert(color, at: index)
        selectedGradient?.colors = colors
    }
    
    private func changeFormat(_ format: GradientColor.Format) {
        selectedGradient?.format = format
    }
    
    private func exportCurrentGradient() {
        guard
            let selected = gradients.first(where: { $0.title == selectedGradient?.title }),
            let index = gradients.index(of: selected) else {
                return
        }
        
        content.gradientVCs[index].produceBackgroundSnapshot()
    }
    
    private func positionChanged(_ position: Float) {
        selectedGradient?.position = position
    }
    
    
    private func handleCurrency(_ currency: GradientAction.Currency) {
        let alert = makeDonateActionSheet(for: currency)
        exported.present(alert, animated: true, completion: nil)
    }
    
    private func handleSelectedColor(with identifier: UUID) {
        guard
            let color = selectedGradient?.colors.first(where: { $0.identifier == identifier }),
            let index = selectedGradient?.colors.index(of: color),
            let count = selectedGradient?.colors.count else {
                return
        }
        
        for index in 0..<count {
            selectedGradient?.colors[index].isSelected = false
        }
        
        selectedGradient?.colors[index].isSelected = true
    }
    
    private func handleDonation(_ donation: GradientAction.Donation) {
        switch donation {
        case let .copyAddress(currency):
            handleCopyWalletAddressToClipboard(walletAddress: currency.address)
        case let .qr(currency):
            donate.currency = currency
            exported.present(UINavigationController(rootViewController: donate), animated: true, completion: nil)
        }
    }
    
    private func handleCopyWalletAddressToClipboard(walletAddress: String) {
        let alert = UIAlertController(
            title: "Coppied.",
            message: "Wallet address \(walletAddress) has been coppied to your clipboard.", preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.exported.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        exported.present(alert, animated: true, completion: nil)
    }
    
    private func makeDonateActionSheet(for currency: GradientAction.Currency) -> UIAlertController {
        let alert = UIAlertController(title: "Thanks for wanting to help!",
                                      message: "You can either copy my \(currency.title) wallet address, or scan my wallet's QR Code.",
            preferredStyle: .actionSheet)
        
        let copyAction = UIAlertAction(title: "Copy my \(currency.title) address", style: .default) { [weak self] _ in
            self?.dispatch(.donate(.copyAddress(currency)))
        }
        
        let qrAction = UIAlertAction(title: "Display my \(currency.title) wallet QR code", style: .default) { [weak self] _ in
            self?.dispatch(.donate(.qr(currency)))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [copyAction, qrAction, cancelAction].forEach { action in
            alert.addAction(action)
        }
        
        return alert
    }
}

extension GradientCoordinator: GradientActionDispatching {
    func dispatch(_ action: GradientAction) {
        switch action {
        case .selectedGradient(let index):
            selectedGradient = gradients[index]
        case .selectedGradientFromDrawer(let identifier):
            
            guard
                let selected = gradients.first(where: { $0.title == identifier }),
                let index = gradients.index(of: selected) else {
                    return
            }
            
            content.scrollToPage(.at(index: index), animated: true)
        case .saveGradient(let image):
            saveImage(image: image)
        case .drawerContextChange(let context):
            drawerContextDidChange(context)
        case .colorIndexChange(let startingIndex, let endingIndex):
            if let gradient = selectedGradient {
                var colors = gradient.colors
                let element = colors.remove(at: startingIndex)
                colors.insert(element, at: endingIndex)
                selectedGradient?.colors = colors
            }
        case let .colorChange(identifier, newColor):
            changeColor(identifier: identifier, newColor: newColor)
        case let .gradientFormatDidChange(format):
            changeFormat(format)
        case .exportCurrentGradient:
            exportCurrentGradient()
        case let .positionChanged(newPosition):
            positionChanged(newPosition)
        case let .formatChanged(format):
            changeFormat(format)
        case .exportDismiss:
            exported.dismiss(animated: true, completion: nil)
        case let .donate(donation):
            handleDonation(donation)
        case .donateDismiss:
            donate.dismiss(animated: true, completion: nil)
        case let .presentDonationOptions(currency):
            handleCurrency(currency)
        case let .gradientColorSelected(identifier):
            handleSelectedColor(with: identifier)
        }
    }
}
