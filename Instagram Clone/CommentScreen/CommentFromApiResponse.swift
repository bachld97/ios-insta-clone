struct CommentFromApiResponse: Decodable {
    let id: Post.Comment.IdType
    let creator: UserInfo
    let ageInSeconds: Int
    let content: String
    
    func toLocalComment() -> Post.Comment {
        return Post.Comment(id: id, creator: creator.toUser(), content: content, replies: [])
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case creator = "creator"
        case ageInSeconds = "age_in_seconds"
        case content = "content"
    }
}
