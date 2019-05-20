import UIKit

class VanishableLabel: UILabel {
    
    let clientUsingAutoLayout: Bool
    
    init(clientUsingAutoLayout: Bool = true) {
        self.clientUsingAutoLayout = clientUsingAutoLayout
        super.init(frame: .zero)
    }
    
    private (set) var correctHeight: CGFloat = 0
    var correctPaddingBot: CGFloat = 0
    var anchorAtBot: NSLayoutYAxisAnchor? = nil
    
    override var text: String? {
        didSet {
            if clientUsingAutoLayout {
                autoLayoutOnSetText()
            } else {
                frameBasedOnSetText()
            }
        }
    }
    
    override func addConstraint(_ constraint: NSLayoutConstraint) {
        super.addConstraint(constraint)
    }
    
    func configureAnchorAtBottom(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat) {
        anchorAtBot = layoutAnchor
        correctPaddingBot = -constant
    }
    
    func configureHeigh(_ height: CGFloat) {
        self.correctHeight = height
    }
    
    
    private func autoLayoutOnSetText() {
        if text?.isEmpty ?? true {
            self.heightAnchor.constraint(
                equalToConstant: 0
            ).isActive = true
            
            if let bot = anchorAtBot {
                self.bottomAnchor.constraint(
                    equalTo: bot, constant: 0
                ).isActive = true
            }
        } else {
            if let bot = anchorAtBot {
                self.bottomAnchor.constraint(
                    equalTo: bot, constant: correctPaddingBot
                    ).isActive = true
            }
            
            self.heightAnchor.constraint(
                equalToConstant: correctHeight
            ).isActive = true
        }
    }
    
    private func frameBasedOnSetText() {
        if text?.isEmpty ?? true {
            self.frame = CGRect(
                x: frame.minX,
                y: frame.minY,
                width: frame.width,
                height: 0
            )
        } else {
            self.frame = CGRect(
                x: frame.minX,
                y: frame.minY,
                width: frame.width,
                height: correctHeight
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
