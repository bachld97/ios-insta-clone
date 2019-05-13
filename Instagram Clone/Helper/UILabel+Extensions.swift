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
}
