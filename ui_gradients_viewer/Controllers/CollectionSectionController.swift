import UIKit

protocol CollectionSectionController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    static func registerReusableTypes(collectionView: UICollectionView)
}

