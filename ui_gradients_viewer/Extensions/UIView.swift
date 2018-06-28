import UIKit

extension UIView {
    public func getSnapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
}

