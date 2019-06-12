import UIKit

class Styles {
    class FeedPostCell {
        static let creatorLabelFont = UIFont.systemFont(ofSize: 12)
        static let likeCountFont = UIFont.boldSystemFont(ofSize: 12)
        static let captionFont = UIFont.systemFont(ofSize: 12)
        static let captionCreatorFont = UIFont.boldSystemFont(ofSize: 12)
        static let timeAgoFont = UIFont.systemFont(ofSize: 11)
        
        static let seeMoreFont = captionFont
        static let seeMoreColor = UIColor.from(r: 0.7, g: 0.7, b: 0.7, a: 0.7)
        
        static let captionHorizontalPadding: CGFloat = 16
        static let collapsedLabelMaxLine: Int = 2
        
        static let timeAgoColor = UIColor.lightGray
    }
    
    class MessageCell {
        static let commentFont = UIFont.systemFont(ofSize: 12)
        static let commentColor = UIColor.black
        
        static let sidePadding: CGFloat = 16
        static let maxMarginOnEmptySide: CGFloat = 128
        
        static let labelBorderColor = UIColor.from(r: 0.7, g: 0.7, b: 0.7, a: 1).cgColor
        static let labelInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let labelMargin = UIEdgeInsets(
            top: 4, left: 0, bottom: 4, right: Styles.MessageCell.sidePadding
        )
    }
}
