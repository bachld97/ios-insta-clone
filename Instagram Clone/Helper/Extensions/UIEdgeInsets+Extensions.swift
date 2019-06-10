import UIKit

extension UIEdgeInsets {
    static func left(_ left: CGFloat, right: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
    }

    static func top(_ top: CGFloat, bottom: CGFloat = 0) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
    }
}
