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
    
    func isTextTruncated(clientUsingAutoLayout: Bool = true) -> Bool {
        if clientUsingAutoLayout { self.layoutIfNeeded() }
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
    
    
    func appendSeeMore(
        prefix: String, text seeMoreText: String,
        seeMoreFont: UIFont? = nil, seeMoreColor: UIColor? = nil,
        clientUsingAutoLayout: Bool = true
    ) {
        guard let attrText = attributedText,
            let seeMoreFont = seeMoreFont ?? font,
            let seeMoreColor = seeMoreColor ?? textColor else {
            return
        }
        if clientUsingAutoLayout { self.layoutIfNeeded() }
        
        let labelWidth = self.frame.width
        let prefixWidth = prefix.widthForFont(self.font)
        let trailingWidth = seeMoreText.widthForFont(seeMoreFont)
        
        guard let firstIndex = startIndexOfLastVisibleLine() else {
            return
        }
        
        var substringTo = firstIndex
        var visibleStringOnLastLine = attrText.substring(from: firstIndex, to: substringTo)
        var visibleStringWidth = visibleStringOnLastLine.string.widthForFont(self.font)
        var prev = firstIndex
        
        var notFoundCorrectPosition = true
        while notFoundCorrectPosition {
            let charSet = CharacterSet.whitespacesAndNewlines
            let str = attrText.string
            let indexForCharBeforeNewLineEncounter = prev
            prev = substringTo

            if lineBreakMode == .byCharWrapping {
                substringTo += 1
            } else {
                substringTo = str.indexOfNext(characterIn: charSet, startingFrom: substringTo)
            }
                
            if substringTo == NSNotFound || visibleStringOnLastLine.string.contains("\n") {
                notFoundCorrectPosition = false
                prev = indexForCharBeforeNewLineEncounter
            } else {
                visibleStringOnLastLine = attrText.substring(from: firstIndex, to: substringTo)
                visibleStringWidth = visibleStringOnLastLine.string.widthForFont(self.font)
                notFoundCorrectPosition = visibleStringWidth + prefixWidth + trailingWidth <= labelWidth
            }
        }
        
        assert(prev >= firstIndex)
        let remainingVisible = attrText.substring(from: 0, to: prev)
        assert(remainingVisible.string.count == prev)
        
        let prefixAttributed = NSMutableAttributedString(
            string: prefix, attributes: [
                NSAttributedString.Key.font: self.font!,
                NSAttributedString.Key.foregroundColor: self.textColor!
            ]
        )
        
        let readMoreAttributed = NSMutableAttributedString(
            string: seeMoreText,
            attributes: [
                NSAttributedString.Key.font: seeMoreFont,
                NSAttributedString.Key.foregroundColor: seeMoreColor
            ]
        )
        
        let result = NSMutableAttributedString(attributedString: remainingVisible)
        result.append(prefixAttributed)
        result.append(readMoreAttributed)
        self.attributedText = result
    }
    
    private func startIndexOfLastVisibleLine() -> Int? {
        guard let attrString = attributedText else {
            return nil
        }
        let numLine: CGFloat = CGFloat(numberOfLines)
        let height = frame.size.height / numLine * (numLine - 1)
        let charSet = CharacterSet.whitespacesAndNewlines

        let str = attrString.string
        var notReachFirstCharOfLastLine = true
        var index = 0
        var prev = 0
        
        repeat {
            prev = index
            if lineBreakMode == .byCharWrapping {
                index += 1
            } else {
                index = str.indexOfNext(characterIn: charSet, startingFrom: index)
            }
            
            notReachFirstCharOfLastLine = (
                index != NSNotFound &&
                index < str.count &&
                attrString.heightToDisplayForSubstring(
                    fromStartUntil: index, fixedWidth: frame.size.width
                ) < height
            )
        } while notReachFirstCharOfLastLine
        return prev + 1
    }
}

extension String {
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
