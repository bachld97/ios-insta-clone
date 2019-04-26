import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func widthForFont(_ font: UIFont) -> CGFloat {
        let attr = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: attr).width
    }
}
