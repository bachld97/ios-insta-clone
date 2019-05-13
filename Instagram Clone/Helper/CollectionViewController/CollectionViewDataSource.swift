import Foundation
import UIKit

open class CollectionViewDataSource: NSObject {
    public var objects: [Any]? = nil
    
    public init(objects: [Any]? = nil) {
        self.objects = objects
    }

    open func firstIndex(predicate: (Any) -> Bool) -> Int? {
        for (index, element) in (objects ?? []).enumerated() {
            if predicate(element) {
                return index
            }
        }
        return nil
    }
    
    open func numberOfSections() -> Int {
        return 1
    }
    
    open func numberOfItems(inSection section: Int) -> Int {
        return objects?.count ?? 0
    }
    
    open func item(at indexPath: IndexPath) -> Any? {
        return objects?[indexPath.item]
    }
    
    open func cellClass(at indexPath: IndexPath) -> CollectionViewCell.Type? {
        return nil
    }
    
    open func cellClasses() -> [CollectionViewCell.Type] {
        return []
    }
}

