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
    
    open func replaceItem(predicate: (Any) -> Bool,
                          transformIfTrue: (Any) -> Any) {
        guard let items = objects else {
            return
        }

        let newObjects = items.map { it -> Any in
            if predicate(it) {
                return transformIfTrue(it)
            }
            return it
        }
        self.objects = newObjects
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
    
    open func headerClass(at indexPath: IndexPath) -> CollectionViewCell.Type? {
        return nil
    }
    
    open func footerClass(at indexPath: IndexPath) -> CollectionViewCell.Type? {
        return nil
    }
    
    open func cellClasses() -> [CollectionViewCell.Type] {
        return []
    }
    
    open func headerClasses() -> [CollectionViewCell.Type] {
        return []
    }
    
    open func footerClasses() -> [CollectionViewCell.Type] {
        return []
    }
    
    open func itemForHeader(at indexPath: IndexPath) -> Any? {
        return nil
    }
    
    open func itemForFooter(at indexPath: IndexPath) -> Any? {
        return nil
    }
}

