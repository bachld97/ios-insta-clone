import UIKit

extension NSAttributedString {
    func heightToDisplay(fixedWidth width: CGFloat) -> CGFloat {
        return self.boundingRect(
            with: .width(width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil).height
    }
    
    func heightToDisplayForSubstring(fromStartUntil index: Int, fixedWidth width: CGFloat) -> CGFloat {
        precondition(index >= 0)
        precondition(index < self.string.count)
        return substring(from: 0, to: index).heightToDisplay(fixedWidth: width)
    }
    
    func substring(from: Int, to: Int) -> NSAttributedString {
        precondition(from >= 0)
        precondition(from <= to)
        precondition(to < self.string.count)
        let range = NSRange(location: from, length: to - from)
        return self.attributedSubstring(from: range)
    }
}
