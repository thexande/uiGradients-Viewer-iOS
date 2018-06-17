import UIKit

protocol CollectionSectionController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func registerReusableTypes(collectionView: UICollectionView)
}

