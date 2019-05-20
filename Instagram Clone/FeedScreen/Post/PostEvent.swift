import UIKit

protocol PostEventDelegate: class {
    func postEvent(_ event: PostEvent, happeningOn cell: CollectionViewCell)
}

enum PostEvent {
    case expandCaption
    case like
    case likeToggle
    case navigateComment
    case navigateShare
    case navigateCreator
    case imagePositionUpdate(index: Int)
}
