import UIKit

open class BaseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    open var dataSource: CollectionViewDataSource? {
        didSet {
            for cls in dataSource?.cellClasses() ?? [] {
                collectionView?.register(
                    cls, forCellWithReuseIdentifier: NSStringFromClass(cls)
                )
            }
            dataSource(didChangeFrom: oldValue, to: dataSource)
        }
    }

    public init(layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        super.init(collectionViewLayout: layout)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        configureBaseViewController()
    }
    
    private func configureBaseViewController() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(
            BaseCollectionViewCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(BaseCollectionViewCell.self)
        )
        // collectionView.refreshControl = refreshControl
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    @objc open func handleRefresh() {
        print("Should reload")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func dataSource(didChangeFrom oldSource: CollectionViewDataSource?,
                         to newSource: CollectionViewDataSource?) {
        refreshControl.endRefreshing()
        collectionView?.reloadData()
    }
    
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inSection: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // Default 1 row layout with arbitrary height
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 48)
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CollectionViewCell
        let cellClass: CollectionViewCell.Type
        
        if let cls = dataSource?.cellClass(at: indexPath) {
            cellClass = cls
        } else if let cls = dataSource?.cellClasses().first {
            cellClass = cls
        } else {
            cellClass = BaseCollectionViewCell.self
        }

        let cellId = NSStringFromClass(cellClass)
        cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId, for: indexPath
        ) as! CollectionViewCell
        
        cell.item = dataSource?.item(at: indexPath)
        return cell
    }
}
