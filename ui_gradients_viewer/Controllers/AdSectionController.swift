import UIKit
import Anchorage

final class AdSectionController: NSObject, CollectionSectionController {
    let parent: UIViewController
    
    init(parent: UIViewController) {
        self.parent = parent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerAdCollectionCell.self), for: indexPath) as? BannerAdCollectionCell else {
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
        collectionView.register(BannerAdCollectionCell.self, forCellWithReuseIdentifier: String(describing: BannerAdCollectionCell.self))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerAdCollectionCell.self), for: indexPath) as? BannerAdCollectionCell else {
                return
        }
        //       cell.adViewController?.banner.load(GADRequest())
    }
}
