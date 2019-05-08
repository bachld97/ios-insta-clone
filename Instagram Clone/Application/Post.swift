import UIKit

struct Post {
    let creator: User
    let content: Content
    let comments: [Comment]
    let aspectRatio: CGFloat = 1
    
    struct Content {
        let caption: String
        let imageUrl: String
        let likeCount: Int
    }
    
    struct Comment {
        let creator: User
        let content: String
        let replies: [Post.Comment]
    }
}

