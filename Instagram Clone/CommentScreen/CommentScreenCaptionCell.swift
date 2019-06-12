import UIKit

class CommentScreenCaptionCell: CollectionViewCell {
    override class func heightForCell(_ item: Any?, cellWidth: CGFloat) -> CGFloat {
        return 10
    }
    
    override func prepareUI() {
        backgroundColor = .red
    }
    
    override func configureCell(with item: Any?) {
        
    }
}
