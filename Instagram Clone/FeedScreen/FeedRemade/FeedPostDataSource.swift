class FeedPostDataSource: CollectionViewDataSource {
    init(posts: [PostItem]) {
        super.init(objects: posts)
    }
    
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [PostCollectionViewCell.self]
    }
}
