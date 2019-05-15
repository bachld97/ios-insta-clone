import UIKit

extension UILabel {
    func textFrom(
        bold: String, nonBold: String,
        boldFont: UIFont = .boldSystemFont(ofSize: 10),
        nonBoldFont: UIFont = .systemFont(ofSize: 10),
        overridingWithCurrentSize: Bool = false
    ) {
        if overridingWithCurrentSize {
            let currentFontSize = self.font.pointSize
            attributedText = bold.toBold(
                withNonBold: nonBold,
                boldFont: boldFont.withSize(currentFontSize),
                nonBoldFont: nonBoldFont.withSize(currentFontSize)
            )
        } else {
            attributedText = bold.toBold(
                withNonBold: nonBold,
                boldFont: boldFont,
                nonBoldFont: nonBoldFont
            )
        }
    }
    
    func isTextTruncated() -> Bool {
        self.layoutIfNeeded()
        let h = self.frame.height
        let w = self.frame.width
        let textHeight: CGFloat
        
        if let text = text, let f = self.font {
            textHeight = text.heightToDisplay(fixedWidth: w, font: f)
        } else if let attrText = attributedText {
            textHeight = attrText.heightToDisplay(fixedWidth: w)
        } else {
            return false
        }
        
        return h < textHeight
    }
    
    
    
    
    #warning("Read and understand this")
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    #warning("Read and understand this")
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
    
    
}
