import UIKit

extension CGSize {
    static func height(_ height: CGFloat) -> CGSize {
        return .init(width: 0, height: height)
    }
    
    static func width(_ width: CGFloat, height: CGFloat = 0) -> CGSize {
        return .init(width: width, height: height)
    }
}
