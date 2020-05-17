import UIKit

class VerticalTopLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let textRect = super.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        let actualRect = CGRect(x: textRect.minX, y: rect.minY, width: textRect.width, height: textRect.height)
        super.drawText(in: actualRect)
    }
}
