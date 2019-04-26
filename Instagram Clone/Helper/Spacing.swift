import Foundation
import UIKit

struct Spacing {
    var top, bottom, left, right: CGFloat
    
    init() {
        self.init(top: 0, bottom: 0, left: 0, right: 0)
    }
    
    init(left: CGFloat, right: CGFloat) {
        self.init(top: 0, bottom: 0, left: left, right: right)
    }
    
    init(top: CGFloat, bottom: CGFloat) {
        self.init(top: top, bottom: bottom, left: 0, right: 0)
    }
    
    init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        (self.top, self.bottom) = (top, bottom)
        (self.left, self.right) = (left, right)
    }
    
    func increaseAll(by ammount: CGFloat) -> Spacing {
        return Spacing(
            top: top + ammount,
            bottom: bottom + ammount,
            left: left + ammount,
            right: right + ammount
        )
    }
}
