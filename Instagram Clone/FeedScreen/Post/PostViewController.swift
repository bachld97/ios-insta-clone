import UIKit

class PostViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    typealias PostCollectionCell = CollectionViewItem<PostCell, Post>
    
    private let fetchPostsUseCase: FetchPostsUseCase
    private let loggedInUser: User
    private let layout = UICollectionViewFlowLayout()
    
    private var posts = [PostCollectionCell]()
    
    init(viewingAs user: User, fetchPosts: FetchPostsUseCase = .init()) {
        self.fetchPostsUseCase = fetchPosts
        loggedInUser = user
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        fetchPostsUseCase.execute(loggedInUser, completion: postsDidLoad(posts:))
    }
    
    private func prepareCollectionView() {
        self.collectionView?.bounces = false
        self.collectionView.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(
            PostCell.self, forCellWithReuseIdentifier: PostCollectionCell.reuseId)
    }
    
    private func postsDidLoad(posts: [Post]) {
        self.posts = posts.map { return PostCollectionCell(item: $0) }
        collectionView?.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return posts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let post = posts[indexPath.row].item
        let headerSize = PostCell.headerSize
        let contentSize = view.frame.width * post.aspectRatio + 56
        let commentSize: CGFloat = 72.0
        
        return CGSize(width: view.frame.width,
                      height: headerSize + contentSize + commentSize)
    }
}
