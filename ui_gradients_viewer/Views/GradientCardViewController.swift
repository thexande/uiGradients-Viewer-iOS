import UIKit
import Anchorage
import GoogleMobileAds

final class GradientCardViewController: UIViewController {
    let gradientCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let cardSection = GradientCardSectionController()
    var sections: [CollectionSectionController] = []
    var numAdsToLoad = 0
    
    var gradients: [GradientColor] = [] {
        didSet {
            configureSections()
        }
    }
    
    private func configureSections() {
        let gradientChunks: [[GradientColor]] = gradients.chunks(10)
        
        let sections: [CollectionSectionController] = gradientChunks.flatMap { gradientChunk -> [CollectionSectionController] in
            let cardSection = GradientCardSectionController()
            cardSection.gradients = gradientChunk
            
            let adSection = AdSectionController(parent: self)
            
            return [cardSection, adSection]
        }
        
        self.sections = sections
        
        DispatchQueue.main.async {
            self.gradientCardCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientCardCollectionView.delegate = self
        gradientCardCollectionView.dataSource = self
        GradientCardSectionController.registerReusableTypes(collectionView: gradientCardCollectionView)
        AdSectionController.registerReusableTypes(collectionView: gradientCardCollectionView)
        
        gradientCardCollectionView.backgroundColor = .clear
        view.addSubview(gradientCardCollectionView)
        gradientCardCollectionView.edgeAnchors == edgeAnchors
    }
}

extension GradientCardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sections[section].collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sections[indexPath.section].collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
