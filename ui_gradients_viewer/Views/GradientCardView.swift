import UIKit
import Anchorage
import GoogleMobileAds

final class GradientCardViewController: UIViewController {
    let gradientCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let cardSection = GradientCardSectionController()
    var adLoader: GADAdLoader?
    var nativeAds: [GADUnifiedNativeAd] = []
    var sections: [CollectionSectionController] = []
    
    var gradients: [GradientColor] = [] {
        didSet {
//            configureSections()
        }
    }

    /// The number of native ads to load (between 1 and 5 for this example).
    let numAdsToLoad = 5
    
    private func configureSections() {
        let gradientChunks: [[GradientColor]] = gradients.chunks(6)
        
        let sections: [CollectionSectionController] = gradientChunks.flatMap { gradientChunk -> [CollectionSectionController] in
            let cardSection = GradientCardSectionController()
            cardSection.gradients = gradientChunk
            
            return [cardSection, AdSectionController()]
        }
        
        self.sections = sections
        gradientCardCollectionView.reloadData()
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = numAdsToLoad
        
        // Prepare the ad loader and start loading ads.
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/8407707713",
                               rootViewController: self,
                               adTypes: [.unifiedNative],
                               options: [options])
        adLoader?.delegate = self
        adLoader?.load(GADRequest())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GradientCardViewController: GADAdLoaderDelegate, GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader,
                  didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("Received native ad: \(nativeAd)")
        
        // Add the native ad to the list of native ads.
        nativeAds.append(nativeAd)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        print("loader finished")
        configureSections()
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
}

extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
