import UIKit
import GoogleMobileAds
import Anchorage

final class GradientCardSectionController: NSObject, CollectionSectionController {
    var gradients: [GradientColor] = []
    weak var dispatch: GradientActionDispatching?
    
    static func registerReusableTypes(collectionView: UICollectionView) {
        collectionView.register(GradientCollectionCell.self, forCellWithReuseIdentifier: String(describing: GradientCollectionCell.self))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gradients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GradientCollectionCell.self), for: indexPath) as? GradientCollectionCell else {
            return UICollectionViewCell()
        }
        cell.gradient = gradients[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 36) / 2, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dispatch?.dispatch(.selectedGradientFromDrawer(indexPath.row))
    }
}

final class AdSectionController: NSObject, CollectionSectionController {
    let parent: UIViewController
    
    init(parent: UIViewController) {
        self.parent = parent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AdMobCollectionCell.self), for: indexPath) as? AdMobCollectionCell else {
            return UICollectionViewCell()
        }
        
        let vc = BannerAdViewController()
        parent.addChildViewController(vc)
        cell.contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: parent)
        vc.view.edgeAnchors == cell.contentView.edgeAnchors
        cell.adViewController = vc
        return cell
    }
    
    static func registerReusableTypes(collectionView: UICollectionView) {
        collectionView.register(AdMobCollectionCell.self, forCellWithReuseIdentifier: String(describing: AdMobCollectionCell.self))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AdMobCollectionCell.self), for: indexPath) as? AdMobCollectionCell else {
                return
        }
//       cell.adViewController?.banner.load(GADRequest())
    }
}
