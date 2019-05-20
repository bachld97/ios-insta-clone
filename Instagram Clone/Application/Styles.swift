import UIKit

class Styles {
    class FeedPostCell {
        static let creatorLabelFont = UIFont.systemFont(ofSize: 12)
        static let likeCountFont = UIFont.systemFont(ofSize: 13)
        static let captionFont = UIFont.systemFont(ofSize: 12)
        static let captionCreatorFont = UIFont.boldSystemFont(ofSize: 12)
        static let timeAgoFont = UIFont.systemFont(ofSize: 12)
        
        static let seeMoreFont = captionFont
        static let seeMoreColor = UIColor.from(r: 0.7, g: 0.7, b: 0.7, a: 0.7)
        
        static let captionHorizontalPadding: CGFloat = 16
        static let collapsedLabelMaxLine: Int = 2
    }
}
