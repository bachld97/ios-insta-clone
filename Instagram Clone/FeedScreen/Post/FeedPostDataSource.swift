import UIKit

class FeedPostDataSource: CollectionViewDataSource {
    var stories: [StoryItem]
    
    var posts: [PostItem] {
        didSet {
            self.objects = posts
        }
    }
    
    init(stories: [StoryItem] = [],
         posts: [PostItem] = []) {
        self.stories = stories
        self.posts = posts
        super.init(objects: posts)
    }
    
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [PostCollectionViewCell.self]
    }
    
    override func cellClass(at indexPath: IndexPath) -> CollectionViewCell.Type? {
        return PostCollectionViewCell.self
    }
    
    override open func headerClasses() -> [CollectionViewCell.Type] {
        return [StoriesCollectionViewCell.self]
    }
    
    override func itemForHeader(at indexPath: IndexPath) -> Any? {
        return stories
    }
}
