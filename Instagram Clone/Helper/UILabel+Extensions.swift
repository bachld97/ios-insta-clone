import UIKit

extension UILabel {
    func textFrom(
        bold: String, nonBold: String,
        boldFont: UIFont = .boldSystemFont(ofSize: 10),
        nonBoldFont: UIFont = .systemFont(ofSize: 10)
    ) {
        let currentFontSize = self.font.pointSize
        
        let str = "\(bold) \(nonBold)"
        let attr = [
            NSAttributedString.Key.font: boldFont.withSize(currentFontSize),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let nonBoldAttr = [
            NSAttributedString.Key.font: nonBoldFont.withSize(currentFontSize)
        ]
        
        let attrString = NSMutableAttributedString(string: str, attributes: attr)
        let nonBoldRange = NSRange.init(location: bold.count + 1, length: nonBold.count)
        attrString.setAttributes(nonBoldAttr, range: nonBoldRange)
        attributedText = attrString
    }
}

