struct CommentItem {
    let isMyComment: Bool
    let comment: Post.Comment
    
    init(
        comment: Post.Comment,
        isMyComment: Bool
        ) {
        self.comment = comment
        self.isMyComment = isMyComment
    }
}
