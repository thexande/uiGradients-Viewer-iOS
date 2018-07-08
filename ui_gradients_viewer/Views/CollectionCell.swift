import UIKit
import Anchorage
import GoogleMobileAds

final class AdMobCollectionCell: UICollectionViewCell {
    var adViewController: BannerAdViewController?
}

final class AdMobCellViewController: UIViewController {
    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!
    /// The native ad view that is being presented.
    var nativeAdView: GADUnifiedNativeAdView!
    
    /// The ad unit ID.
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    
    /// The height constraint applied to the ad view, where necessary.
    var heightConstraint : NSLayoutConstraint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        guard
            let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? GADUnifiedNativeAdView else {
                assert(false, "Could not load nib file for adView")
        }
        
        setAdView(adView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAdView(_ view: GADUnifiedNativeAdView) {
        // Remove the previous ad view.
        nativeAdView = view
        self.view.addSubview(nativeAdView)

        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
        nativeAdView.edgeAnchors == self.view.edgeAnchors
    }
    
    func refreshAd() {
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: self,
                               adTypes: [ .unifiedNative ], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
}

extension AdMobCellViewController: GADVideoControllerDelegate {
    
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        print("Video playback has ended.")
    }
}

extension AdMobCellViewController: GADAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}


extension AdMobCellViewController: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAdView.nativeAd = nativeAd
        
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        
        // Deactivate the height constraint that was set when the previous video ad loaded.
        heightConstraint?.isActive = false
        
        // Populate the native ad view with the native ad assets.
        // Some assets are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        // Some native ads will include a video asset, while others do not. Apps can use the
        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
        // UI accordingly.
        // The UI for this controller constrains the image view's height to match the media view's
        // height, so by changing the one here, the height of both views are being adjusted.
        if let controller = nativeAd.videoController, controller.hasVideoContent() {
            // The video controller has content. Show the media view.
            if let mediaView = nativeAdView.mediaView {
                mediaView.isHidden = false
                nativeAdView.imageView?.isHidden = true
                // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
                // ratio of the video it displays.
                if controller.aspectRatio() > 0 {
                    heightConstraint = NSLayoutConstraint(item: mediaView,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: mediaView,
                                                          attribute: .width,
                                                          multiplier: CGFloat(1 / controller.aspectRatio()),
                                                          constant: 0)
                    heightConstraint?.isActive = true
                }
            }
            // By acting as the delegate to the GADVideoController, this ViewController receives messages
            // about events in the video lifecycle.
            controller.delegate = self
        }
        else {
            // If the ad doesn't contain a video asset, the first image asset is shown in the
            // image view. The existing lower priority height constraint is used.
            nativeAdView.mediaView?.isHidden = true
            nativeAdView.imageView?.isHidden = false
            let firstImage: GADNativeAdImage? = nativeAd.images?.first
            (nativeAdView.imageView as? UIImageView)?.image = firstImage?.image
        }
        // These assets are not guaranteed to be present, and should be checked first.
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        if let _ = nativeAd.icon {
            nativeAdView.iconView?.isHidden = false
        } else {
            nativeAdView.iconView?.isHidden = true
        }
//        (nativeAdView?.starRatingView as? UIImageView)?.image = imageOfStars(from:nativeAd.starRating)
        if let _ = nativeAd.starRating {
            nativeAdView.starRatingView?.isHidden = false
        }
        else {
            nativeAdView.starRatingView?.isHidden = true
        }
        (nativeAdView?.storeView as? UILabel)?.text = nativeAd.store
        if let _ = nativeAd.store {
            nativeAdView.storeView?.isHidden = false
        }
        else {
            nativeAdView.storeView?.isHidden = true
        }
        (nativeAdView?.priceView as? UILabel)?.text = nativeAd.price
        if let _ = nativeAd.price {
            nativeAdView.priceView?.isHidden = false
        }
        else {
            nativeAdView.priceView?.isHidden = true
        }
        (nativeAdView?.advertiserView as? UILabel)?.text = nativeAd.advertiser
        if let _ = nativeAd.advertiser {
            nativeAdView.advertiserView?.isHidden = false
        }
        else {
            nativeAdView.advertiserView?.isHidden = true
        }
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
    }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension AdMobCellViewController: GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}
