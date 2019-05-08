import UIKit

protocol ConfigurableCell{
    associatedtype Item
    func configure(item: Item)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class CollectionViewItem<CellType: ConfigurableCell, Item>: CellConfigurator
    where CellType.Item == Item, CellType: UICollectionViewCell {
    
    static var reuseId: String {
        return String(describing: CellType.self)
    }
    
    let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(item: item)
    }
}
