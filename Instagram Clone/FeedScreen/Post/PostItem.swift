import UIKit

struct PostItem {
    let isTextExpanded: Bool
    let selectedImage: Int
    var cachedExpandedHeight: CGFloat = -1
    var cachedCollapseHeight: CGFloat = -1
    
    let post: Post
    
    init(_ post: Post,
         _ expanded: Bool = false,
         _ selectedImage: Int = 0) {
        self.isTextExpanded = expanded
        self.selectedImage = selectedImage
        self.post = post
    }
    
    var likeText: String {
        let count = post.content.likeCount
        
        if count == 0 {
            return ""
        } else if count == 1 {
            return "1 like".localized
        }
        
        return "\(post.content.likeCount)" + " likes".localized
    }
    
    var timeAgoText: String = {
        return "10 years ago"
    }()
    
    func toExpanded() -> PostItem {
        return PostItem(post, true, selectedImage)
    }
    
    func toggleLike() -> PostItem {
        return PostItem(post.reverseLike(), isTextExpanded, selectedImage)
    }
    
    func toLiked() -> PostItem {
        return PostItem(post.liked(), isTextExpanded, selectedImage)
    }
    
    func setCurrentImage(_ index: Int) -> PostItem {
        return PostItem(post, isTextExpanded, index)
    }
}
