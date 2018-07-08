import UIKit
import Anchorage
import GoogleMobileAds

final class GradientCardViewController: UIViewController {
    let gradientCardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let cardSection = GradientCardSectionController()
    var adLoader: GADAdLoader?
    
    
    /// The number of native ads to load (between 1 and 5 for this example).
    let numAdsToLoad = 5
    
    /// The native ads.
    var nativeAds: [GADUnifiedNativeAd] = [] {
        didSet {
            print("ad count", nativeAds.count)
        }
    }
    
    var gradients: [GradientColor] = [] {
        didSet {
            cardSection.gradients = gradients
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientCardCollectionView.delegate = cardSection
        gradientCardCollectionView.dataSource = cardSection
        cardSection.registerReusableTypes(collectionView: gradientCardCollectionView)
        gradientCardCollectionView.backgroundColor = .clear
        view.addSubview(gradientCardCollectionView)
        gradientCardCollectionView.edgeAnchors == edgeAnchors
        
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
    
}
