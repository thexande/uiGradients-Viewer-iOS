import UIKit
import Anchorage
import GoogleMobileAds

final class BannerAdCollectionCell: UICollectionViewCell {
    var adViewController: BannerAdViewController?
}

final class BannerAdViewController: UIViewController {
    let banner = GADBannerView(adSize: kGADAdSizeLargeBanner)
    
    func prepareForReuse() {
        banner.load(GADRequest())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        banner.adUnitID = Obfuscator().reveal(key: ObfuscatedConstants.exportBannerId)
        banner.rootViewController = self
        banner.delegate = self
        view.addSubview(banner)
        banner.load(GADRequest())
        banner.centerAnchors == view.centerAnchors
    }
}

extension BannerAdViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

