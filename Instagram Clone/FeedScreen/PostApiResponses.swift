struct PostFromApiResponse: Decodable {
    let id: Post.IdType
    let creator: UserInfo
    let caption: String
    let ageInSeconds: Int
    let likeCount: Int
    let likedByUser: Bool
    let content: [String]
    let comments: [CommentFromApiResponse]
    
    func toLocalPost() -> Post {
        let comments = self.comments.map {
            $0.toLocalComment()
        }
        
        let content = Post.Content(
            caption: caption,
            images: self.content.map { ICImage(url: $0) },
            likeCount: likeCount,
            likedByMe: likedByUser)

        let creator = self.creator.toUser()
        
        return Post(
            id: id, creator: creator, content: content,
            ageInSeconds: ageInSeconds, comments: comments
        )
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
    
//    struct Comment: Decodable {
//        let id: Post.Comment.IdType
//        let creator: UserInfo
//        let content: String
//        let ageInSeconds: Int
//        
//        private enum CodingKeys: String, CodingKey {
//            case id = "id"
//            case creator = "creator"
//            case content = "content"
//            case ageInSeconds = "age_in_seconds"
//        }
//        
//        func toLocalComment() -> Post.Comment {
//            return Post.Comment(
//                id: id,
//                creator: creator.toUser(),
//                content: content,
//                replies: []
//            )
//        }
//    }
}

struct LikePostResponse: Decodable {
    let success: Bool
    let errorMessage: String?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case errorMessage = "error"
    }
}

struct UnlikePostResponse: Decodable {
    let success: Bool
    let errorMessage: String?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case errorMessage = "error"
    }
}
