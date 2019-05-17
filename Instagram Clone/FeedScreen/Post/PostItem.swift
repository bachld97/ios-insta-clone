import UIKit

class PostItem {
    var isTextExpanded = false
    var cachedExpandedHeight: CGFloat = -1
    var cachedCollapseHeight: CGFloat = -1
    
    let post: Post
    
    init(_ post: Post) {
        self.post = post
    }
    
    var likeText: String {
        let add = post.content.likedByMe ? 1 : 0
        return "\(post.content.likeCount + add)" + " likes".localized
    }
    
    lazy var timeAgoText: String = {
        return "10 years ago"
    }()
}
