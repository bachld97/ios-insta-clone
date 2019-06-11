import UIKit

class Post: Equatable {
    init(id: IdType,
         creator: User,
         content: Content,
         ageInSeconds: Int,
         comments: [Comment]) {
        self.postId = id
        self.creator = creator
        self.content = content
        self.comments = comments
        self.ageInSeconds = ageInSeconds
    }
    
    typealias IdType = Int
    
    let postId: IdType
    let creator: User
    let content: Content
    let comments: [Comment]
    let ageInSeconds: Int
    
    class Content {
        let caption: String
        let images: [ICImage]
        var likeCount: Int
        var likedByMe: Bool
        
        init(caption: String,
             images: [ICImage],
             likeCount: Int,
             likedByMe: Bool) {
            self.caption = caption
            self.images = images
            self.likeCount = likeCount
            self.likedByMe = likedByMe
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
    
    func reverseLike() -> Post {
        content.likedByMe = !content.likedByMe
        if content.likedByMe {
            content.likeCount += 1
        } else {
            content.likeCount -= 1
        }
        return self
    }
    
    func liked() -> Post {
        if !content.likedByMe {
            content.likeCount += 1
        }
        content.likedByMe = true
        return self
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.postId == rhs.postId
    }
}
