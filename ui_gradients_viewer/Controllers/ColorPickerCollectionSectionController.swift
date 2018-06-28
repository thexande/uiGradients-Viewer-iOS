import UIKit

final class ColorPickerCollectionSectionController: NSObject, CollectionSectionController {
    var items: [GradientColor.Color] = []
    weak var dispatcher: GradientActionDispatching?
    
    func registerReusableTypes(collectionView: UICollectionView) {
        collectionView.register(ColorPickerCollectionCell.self,
                                forCellWithReuseIdentifier: String(describing: ColorPickerCollectionCell.self))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ColorPickerCollectionCell.self),
                                                            for: indexPath) as? ColorPickerCollectionCell else {
                                                                return UICollectionViewCell()
        }
        cell.color = items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (collectionView.frame.width - CGFloat(((items.count - 1) * 18))) / CGFloat(items.count),
            height: collectionView.frame.height
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {
        print("Starting Index: \(sourceIndexPath.item)")
        print("Ending Index: \(destinationIndexPath.item)")
        dispatcher?.dispatch(.colorIndexChange(startingIndex: sourceIndexPath.item,
                                               endingIndex: destinationIndexPath.item))
    }
}
