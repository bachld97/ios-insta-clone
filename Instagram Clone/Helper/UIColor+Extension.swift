import UIKit

extension UIColor {
    static func from(r: Int = 255, g: Int = 255, b: Int = 255, a: Int = 255) -> UIColor {
        precondition(r >= 0 && r <= 255)
        precondition(g >= 0 && g <= 255)
        precondition(b >= 0 && b <= 255)
        precondition(a >= 0 && a <= 255)

        let rr = CGFloat(r)
        let gg = CGFloat(g)
        let bb = CGFloat(b)
        let aa = CGFloat(a)
        return UIColor(red: rr / 255, green: gg / 255, blue: bb / 255, alpha: aa / 225)
    }
}
