import UIKit

extension String {

    func size(_ font: UIFont) -> CGSize {
        return self.size(font, constraint: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }

    func size(_ font: UIFont, constraint: CGSize) -> CGSize {
        if self.isEmpty {
            return CGSize.zero
        }
        let context = NSStringDrawingContext()
        let boundingBox = (self as NSString).boundingRect(with: constraint,
                                                          options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                          attributes: [NSAttributedStringKey.font: font],
                                                          context: context).size
        return CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }
}
