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
    
    class Content {
        let caption: String
        let images: [ICImage]
        var likeCount: Int
        var likedByMe: Bool = false
        
        init(caption: String,
             images: [ICImage],
             likeCount: Int) {
            self.caption = caption
            self.images = images
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
}


struct PostFromApiResponse: Decodable {
    let id: Post.IdType
    let creator: UserInfo
    let caption: String
    let ageInSeconds: Int
    let likeCount: Int
    let likedByUser: Bool
    let content: [String]
    let comments: [PostComment]
    
    func toLocalPost() -> Post {
        let comments = self.comments.map {
            $0.toLocalComment()
        }
        
        let content = Post.Content(
            caption: caption,
            images: self.content.map { ICImage(url: $0) },
            likeCount: likeCount)
        
        let creator = self.creator.toUser()
        
        return Post(id: id, creator: creator, content: content, comments: comments)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case creator = "creator_info"
        case caption = "caption"
        case ageInSeconds = "age_in_seconds"
        case likeCount = "like_count"
        case comments = "comments"
        case likedByUser = "liked_by_user"
        case content = "content"
    }
    
    struct PostComment: Decodable {
        // let id: Post.Comment.IdType
        let id: Int
        let creator: UserInfo
        let content: String
        let ageInSeconds: Int
        
        private enum CodingKeys: String, CodingKey {
            case id = "id"
            case creator = "creator"
            case content = "content"
            case ageInSeconds = "age_in_seconds"
        }
        
        func toLocalComment() -> Post.Comment {
            return Post.Comment(
                creator: creator.toUser(),
                content: content,
                replies: []
            )
        }
    }
}
