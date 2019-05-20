import UIKit

class CaptionLabel: UILabel {
    var creatorNameFont = UIFont.boldSystemFont(ofSize: 12)
    var captionFont = UIFont.systemFont(ofSize: 12)
    var seeMoreFont = UIFont.systemFont(ofSize: 12)
    var seeMoreColor = UIColor.black
    var seeMorePrefix: String
    var seeMoreText: String
    var numberOfLinesWhenCollapsed: Int
    
    var currentCaption: String = ""
    var currentCreatorName: String = ""
    
    init(numberOfLinesWhenCollapsed: Int = 2,
         seeMorePrefix: String = "… ",
         seeMoreText: String = "more") {
        self.numberOfLinesWhenCollapsed = numberOfLinesWhenCollapsed
        self.seeMorePrefix = seeMorePrefix
        self.seeMoreText = seeMoreText
        super.init(frame: .zero)
        numberOfLines = numberOfLinesWhenCollapsed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        setCaption(currentCaption, creatorName: currentCreatorName, collapseText: false)
    }
    
    func collapse() {
        setCaption(currentCaption, creatorName: currentCreatorName, collapseText: true)
    }
    
    func setCaption(_ caption: String, creatorName: String, collapseText: Bool) {
        self.currentCaption = caption
        self.currentCreatorName = creatorName
        
        self.textFrom(
            bold: creatorName, nonBold: caption,
            boldFont: creatorNameFont, nonBoldFont: captionFont
        )
        
        if collapseText {
            numberOfLines = numberOfLinesWhenCollapsed
            if isTextTruncated() {
                appendSeeMore(
                    prefix: seeMorePrefix, text: seeMoreText,
                    seeMoreFont: seeMoreFont, seeMoreColor: seeMoreColor
                )
            }
        } else {
            numberOfLines = 0
        }
    }
}
