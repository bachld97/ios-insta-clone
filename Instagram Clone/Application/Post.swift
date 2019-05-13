import UIKit

class Post {
    init(id: IdType,
         creator: User,
         content: Content,
         comments: [Comment]) {
        self.postId = id
        self.creator = creator
        self.content = content
        self.comments = comments
    }
    
    typealias IdType = Int
    
    let postId: IdType
    let creator: User
    let content: Content
    let comments: [Comment]
    let aspectRatio: CGFloat = 1
    
    class Content {
        let caption: String
        let imageUrl: String
        let likeCount: Int
        var likedByMe: Bool = false
        
        init(caption: String,
             imageUrl: String,
             likeCount: Int) {
            self.caption = caption
            self.imageUrl = imageUrl
            self.likeCount = likeCount
        }
    }
    
    class Comment {
        init(creator: User,
             content: String,
             replies: [Post.Comment]) {
            self.creator = creator
            self.content = content
            self.replies = replies
        }
        
        let creator: User
        let content: String
        let replies: [Post.Comment]
    }
}

