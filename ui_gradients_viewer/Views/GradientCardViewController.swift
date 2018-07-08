import UIKit
import Anchorage
import GoogleMobileAds

final class GradientCardViewController: UIViewController {
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var sections: [CollectionSectionController] = []
    weak var dispatcher: GradientActionDispatching?
    
    var gradients: [GradientColor] = [] {
        didSet {
            configureSections()
        }
    }
    
    private func mapSectionsFromGradientChunks(_ gradientChunk: [GradientColor]) -> [CollectionSectionController] {
        let cardSection = GradientCardSectionController()
        cardSection.gradients = gradientChunk
        cardSection.dispatch = dispatcher
        let adSection = AdSectionController(parent: self)
        return [cardSection, adSection]
    }
    
    private func configureSections() {
        self.sections = gradients.chunks(10).flatMap(mapSectionsFromGradientChunks(_:))
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        GradientCardSectionController.registerReusableTypes(collectionView: collection)
        AdSectionController.registerReusableTypes(collectionView: collection)
        collection.backgroundColor = .clear
        view.addSubview(collection)
        collection.edgeAnchors == edgeAnchors
    }
}

extension GradientCardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sections[section].collectionView(collectionView,
                                                numberOfItemsInSection: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].collectionView(collectionView,
                                                          cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].collectionView?(collectionView,
                                                           layout: collectionViewLayout,
                                                           sizeForItemAt: indexPath) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].collectionView?(collectionView,
                                                 layout: collectionViewLayout,
                                                 insetForSectionAt: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        sections[indexPath.section].collectionView?(collectionView,
                                                    willDisplay: cell,
                                                    forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].collectionView?(collectionView, didSelectItemAt: indexPath)
    }
}
