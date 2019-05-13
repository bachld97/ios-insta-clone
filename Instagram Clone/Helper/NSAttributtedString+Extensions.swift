import UIKit

extension NSAttributedString {
    func heightToDisplay(fixedWidth width: CGFloat) -> CGFloat {
        return self.boundingRect(
            with: .width(width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil).height
    }
}
