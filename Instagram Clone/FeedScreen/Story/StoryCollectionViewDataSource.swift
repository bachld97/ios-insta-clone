class StoryCollectionViewDataSource: CollectionViewDataSource {
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [StoryCollectionViewCell.self]
    }
}
