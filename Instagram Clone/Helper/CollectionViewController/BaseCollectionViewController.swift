import UIKit

open class BaseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    open var loadingSpinnerView: UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.color = .black
        return loadingSpinner
    }()
    
    open var dataSource: CollectionViewDataSource? {
        didSet {
            registerCustomCells()
            registerCustomHeaders()
            registerCustomFooters()
            dataSource(didChangeFrom: oldValue, to: dataSource)
        }
    }
    
    private func registerCustomCells() {
        for cls in dataSource?.cellClasses() ?? [] {
            collectionView?.register(
                cls, forCellWithReuseIdentifier: NSStringFromClass(cls)
            )
        }
    }
    
    private func registerCustomHeaders() {
        for cls in dataSource?.headerClasses() ?? [] {
            collectionView?.register(
                cls,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: NSStringFromClass(cls))
        }
    }
    
    private func registerCustomFooters() {
        for cls in dataSource?.footerClasses() ?? [] {
            collectionView?.register(
                cls,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: NSStringFromClass(cls))
        }
    }
    

    public init(layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        super.init(collectionViewLayout: layout)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        configureBaseViewController()
        
        view.addSubview(loadingSpinnerView)
        loadingSpinnerView.centerInSuperview()
        loadingSpinnerView.startAnimating()
    }
    
    
    private func configureBaseViewController() {
        registerDefaultCells()
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
    }
    
    private func registerDefaultCells() {
        let cellCls = DefaultCollectionViewCell.self
        collectionView.register(
            cellCls, forCellWithReuseIdentifier: NSStringFromClass(cellCls)
        )
        
        let headerCls = DefaultCollectionHeader.self
        collectionView.register(
            headerCls,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NSStringFromClass(headerCls))
        
        let footerCls = DefaultCollectionFooter.self
        collectionView.register(
            footerCls,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: NSStringFromClass(footerCls))
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
        loadingSpinnerView.stopAnimating()
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

    // Default 1 column layout with arbitrary height
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .width(view.frame.width, height: 48)
    }
    
    // Hide header by default
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return .zero
    }
    
    // Hide footer by default
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return .zero
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CollectionViewCell
        let cellClass: CollectionViewCell.Type
        
        if let cls = dataSource?.cellClass(at: indexPath) {
            cellClass = cls
        } else if let cls = dataSource?.cellClasses().first {
            cellClass = cls
        } else {
            cellClass = DefaultCollectionViewCell.self
        }

        let cellId = NSStringFromClass(cellClass)
        cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId, for: indexPath
        ) as! CollectionViewCell
        
        cell.item = dataSource?.item(at: indexPath)
        cell.viewController = self
        return cell
    }
    
    override open func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return self.collectionView(collectionView, headerAt: indexPath)
        } else {
            return self.collectionView(collectionView, footerAt: indexPath)
        }
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        headerAt indexPath: IndexPath
    ) -> UICollectionReusableView {
        let headerCell: CollectionViewCell
        let kind = UICollectionView.elementKindSectionHeader
        let headerCls: CollectionViewCell.Type
        if let cls = dataSource?.headerClass(at: indexPath) {
            headerCls = cls
        } else if let cls = dataSource?.headerClasses().first {
            headerCls = cls
        } else {
            headerCls = DefaultCollectionHeader.self
        }
        
        let headerIdentifier = NSStringFromClass(headerCls)
        headerCell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerIdentifier,
            for: indexPath
        ) as! CollectionViewCell
        
        headerCell.item = dataSource?.itemForHeader(at: indexPath)
        return headerCell
    }
    
    open func collectionView(
        _ collectionView: UICollectionView,
        footerAt indexPath: IndexPath
    ) -> UICollectionReusableView {
        let footerCell: CollectionViewCell
        let kind = UICollectionView.elementKindSectionFooter
        let footerCls = DefaultCollectionFooter.self
        let footerIdentifier = NSStringFromClass(footerCls)
        
        footerCell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: footerIdentifier,
            for: indexPath
            ) as! CollectionViewCell
        
        return footerCell
    }

    
    func flowLayout() -> UICollectionViewFlowLayout? {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }
}
