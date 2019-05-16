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
    
    func toBold(withNonBold nonBold: String,
                  boldFont: UIFont, nonBoldFont: UIFont) -> NSAttributedString {
        let bold = self
        let str = "\(bold) \(nonBold)"
        let attr = [
            NSAttributedString.Key.font: boldFont,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let nonBoldAttr = [
            NSAttributedString.Key.font: nonBoldFont
        ]
        
        let attrString = NSMutableAttributedString(string: str, attributes: attr)
        let nonBoldRange = NSRange.init(location: bold.count + 1, length: nonBold.count)
        attrString.setAttributes(nonBoldAttr, range: nonBoldRange)
        return attrString
    }
    
    func heightToDisplay(
        fixedWidth width: CGFloat, font: UIFont) -> CGFloat {
        // without subtracting the width it is not accurate, dont know why
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: font]
        let estimatedFrame = NSString(
            string: self
        ).boundingRect(
            with: size, options: .usesLineFragmentOrigin,
            attributes: attributes, context: nil
        )
        return estimatedFrame.height
    }
}
