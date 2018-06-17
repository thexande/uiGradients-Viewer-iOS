import UIKit
import Pulley

enum GradientAction {
    case selectedGradient(Int)
}

protocol GradientActionDispatching: class {
    func dispatch(_ action: GradientAction)
}

final class GradientCoordinator {
    let root: PulleyViewController?
    let content: RootPageViewController
    let drawer: SelectGradientViewController
    var gradients: [GradientColor] = []
    
    var selectedGradient: GradientColor? {
        didSet {
            drawer.gradient = selectedGradient
        }
    }
    
    init() {
        let drawer = SelectGradientViewController()
        self.drawer = drawer
        
        let content = RootPageViewController()
        self.content = content
        
        root = PulleyViewController(contentViewController: self.content, drawerViewController: self.drawer)
        
        self.content.dispatch = self
        
        _ = GradientHelper.produceGradients { [weak self] (gradients) in
            guard let strongSelf = self else { return }
            strongSelf.gradients = gradients
            DispatchQueue.main.async {
                let index = Int.random(in: 0 ..< gradients.count)
                strongSelf.content.startingIndex = index
                strongSelf.content.gradientVCs = gradients.map(GradientDetailViewController.init)
                
                
                strongSelf.selectedGradient = gradients[index]
                strongSelf.content.scrollToPage(.at(index: index), animated: true)
            }
        }
    }
}

extension GradientCoordinator: GradientActionDispatching {
    func dispatch(_ action: GradientAction) {
        switch action {
        case .selectedGradient(let index):
            selectedGradient = gradients[index]
        }
    }
}

