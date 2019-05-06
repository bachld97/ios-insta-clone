import UIKit

class LoginButton: UIButton {
    
    private (set) var originalBackground: UIColor
    private (set) var disabledColor: UIColor
    private (set) var highlightColor: UIColor
    
    private var activityIndicator: UIActivityIndicatorView
    private let indicatorVerticalPadding: CGFloat = 2
    
    init(disabledColor: UIColor, highlightColor: UIColor,
         backgroundColor: UIColor) {
        self.disabledColor = disabledColor
        self.highlightColor = highlightColor
        self.originalBackground = backgroundColor
        self.activityIndicator = UIActivityIndicatorView(style: .white)
        super.init(frame: .zero)
        
        setTitle("Log in".localized, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = originalBackground
            } else if isHighlighted {
                backgroundColor = highlightColor
            } else {
                backgroundColor = originalBackground
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightColor
            } else if isEnabled {
                backgroundColor = originalBackground
            } else {
                backgroundColor = disabledColor
            }
        }
    }
    
    func showLoading() {
        isEnabled = false
        setTitle("", for: .normal)
        let dimen = frame.height - 2 * indicatorVerticalPadding
        activityIndicator.frame = CGRect(
            x: (frame.width - dimen) / 2,
            y: indicatorVerticalPadding,
            width: dimen,
            height: dimen
        )
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func showwNotLoading() {
        isEnabled = true
        setTitle("Login".localized, for: .normal)
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
