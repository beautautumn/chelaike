import UIKit
import SnapKit

class CarItemPriceLabel: UILabel {
    
    var price: String? {
        didSet {
            self.setLabelText()
        }
    }

    var title: String? {
        didSet {
            self.setLabelText()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    fileprivate func initViews() {
        self.textAlignment = .right
        self.textColor = ColorUtils.orangeTextColor
    }
    
    fileprivate func setLabelText() {
        if let price = self.price {
            self.font = UIFont.systemFont(ofSize: 16)
            var text: String
            if let title = self.title {
                text = "\(title)\(price)万"
            } else {
                text = "\(price)万"
            }
            let attributedText = NSMutableAttributedString(string: text)
            if !(self.title?.isEmpty ?? true) {
                attributedText.setAttributes(
                    [
                        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10),
                        NSAttributedStringKey.foregroundColor: ColorUtils.orangeTextColor
                    ], range: NSMakeRange(0, self.title!.count)
                )
            }
            attributedText.setAttributes(
                [
                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10),
                    NSAttributedStringKey.foregroundColor: ColorUtils.orangeTextColor
                ], range: NSMakeRange(text.count - 1, 1)
            )
            self.attributedText = attributedText
        } else {
            self.font = UIFont.systemFont(ofSize: 12)
            self.attributedText = NSMutableAttributedString(string: "待定价")
        }
    }
}
