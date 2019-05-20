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
    
    func subString(from: Int, to: Int) -> String {
        precondition(from >= 0)
        precondition(to < self.count)
        precondition(from <= to)
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
    
    func subString(from: Int, length: Int) -> String {
        precondition(from >= 0)
        precondition(length >= 0)
        precondition(from + length < self.count)
        return subString(from: from, to: from + length)
    }
    
    func countOccurrences(forSubstring s: String) -> Int
    {
        return components(separatedBy: s).count - 1
    }
    
    func indexOfNext(characterIn charSet: CharacterSet, startingFrom index: Int) -> Int {
        precondition(index < self.count)
        
        let remainingLookupRange = NSRange(
            location: index + 1, length: self.count - index - 1
        )
        return (self as NSString).rangeOfCharacter(
            from: charSet,
            options: [],
            range: remainingLookupRange
            ).location
    }

}
