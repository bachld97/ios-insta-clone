import UIKit

class CommentsDataSource: CollectionViewDataSource {
    func cloneSelf(withExtraComments comments: [CommentItem]) -> CommentsDataSource {
        guard var objects = objects else {
            return CommentsDataSource(objects: comments)
        }
        objects.append(contentsOf: comments)
        return CommentsDataSource(objects: objects)
    }
    
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [
            CommentCell.self,
            CommentScreenCaptionCell.self
        ]
    }
    
    override func cellClass(at indexPath: IndexPath) -> CollectionViewCell.Type? {
        if indexPath.item == 0 {
            return CommentScreenCaptionCell.self
        } else {
            return CommentCell.self
        }
    }
}
