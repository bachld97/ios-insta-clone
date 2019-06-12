import UIKit

class CommentCell: CollectionViewCell {
    override class func heightForCell(_ item: Any?, cellWidth: CGFloat) -> CGFloat {
        return 10
    }
    
    override func prepareUI() {
        backgroundColor = .yellow
    }
    
    override func configureCell(with item: Any?) {
        
    }
}
