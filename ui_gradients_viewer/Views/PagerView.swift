import UIKit
import Anchorage

protocol PagerDelegate: class {
    func numberOfPages() -> Int
}

protocol PagerDatasource: class {
    func pageForItem(at indexPath: IndexPath) -> UIView
}

final class PagerView: UIView {
    let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var pagerDelegate: PagerDelegate?
    weak var pagerDatasource: PagerDatasource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collection.isPagingEnabled = true
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.backgroundColor = .clear
        collection.edgeAnchors == edgeAnchors
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        collection.showsHorizontalScrollIndicator = false
        
        if let layout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PagerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagerDelegate?.numberOfPages() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        
        guard let view = pagerDatasource?.pageForItem(at: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.contentView.addSubview(view)
        view.edgeAnchors == cell.contentView.edgeAnchors
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
