import UIKit

class FeedPostDataSource: CollectionViewDataSource {
    var stories: [StoryItem] {
        didSet {
            updateSuperObjects()
        }
    }
    
    var posts: [PostItem] {
        didSet {
            updateSuperObjects()
        }
    }
    
    private func updateSuperObjects() {
        var superObjects: [Any] = self.posts
        superObjects.insert(stories, at: 0)
        self.objects = superObjects
    }
    
    init(stories: [StoryItem] = [],
         posts: [PostItem] = []) {
        self.stories = stories
        self.posts = posts
        
        var superObjects: [Any] = self.posts
        superObjects.insert(stories, at: 0)
        super.init(objects: superObjects)
    }
    
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [StoriesCollectionViewCell.self, PostCollectionViewCell.self]
    }
    
    override open func cellClass(at indexPath: IndexPath) -> CollectionViewCell.Type? {
        if indexPath.item == 0 {
            return StoriesCollectionViewCell.self
        } else {
            return PostCollectionViewCell.self
        }
    }
}
