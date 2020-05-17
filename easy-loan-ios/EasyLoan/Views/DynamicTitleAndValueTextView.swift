import UIKit
import ZMKnife
import SpriteKit

class DynamicTitleAndValueTextView: TitleAndValueTextView {

    var minHeight: CGFloat = 44
    var topPadding: CGFloat = 10
    var bottomPading: CGFloat = 10

    var placeholder: String? {
        didSet {
            self.valueLabel.placeholder = self.placeholder
        }
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }

    var value: String? {
        didSet {
            self.valueLabel.text = self.value
            let constraint = CGSize(width: UIScreen.main.bounds.size.width - self.calculateValueLabelSpace(),
                                    height: CGFloat.greatestFiniteMagnitude)
            self.valueLabelHeight = self.value?.size(self.valueLabel.font, constraint: constraint).height
            let height = (self.valueLabelHeight ?? 0) + self.topPadding + self.bottomPading
            self.snp.remakeConstraints { (make) in
                make.height.equalTo(height > self.minHeight ? height : self.minHeight)
            }
            self.setNeedsDisplay()
        }
    }
    
    var isError: Bool = false {
        didSet {
            if self.isError {
                self.valueLabel.textColor = ColorUtils.darkRedTextColor
                self.addSubview(self.errorImageView)
            } else {
                self.valueLabel.textColor = ColorUtils.fontColor
                self.errorImageView.removeFromSuperview()
            }
        }
    }

    fileprivate var valueLabelHeight: CGFloat?
    fileprivate let errorImageView = UIImageView()

    func calculateValueLabelSpace() -> CGFloat {
        let space = self.leftPadding + self.rightPadding + (self.titleLabelWidth ?? 0)
        return self.isError ? space + 20 : space
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if self.isError && self.subviews.contains(self.errorImageView) {
            self.errorImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(self.titleLabel.snp.right)
                make.top.equalTo(self.valueLabel).offset(2)
                make.size.equalTo(14)
            }
        }
    }

    override func updateValueLabelConstraints() {
        if self.isError {
            self.valueLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(self.titleLabel.snp.right).offset(20)
                make.right.equalTo(self).offset(-self.rightPadding)
                make.top.equalTo(self).offset(self.topPadding)
                make.height.equalTo(self.valueLabelHeight ?? 0)
            }
        } else {
            super.updateValueLabelConstraints()
        }
    }
    
    override func initViews() {
        super.initViews()
        self.titleLabel.textColor = ColorUtils.fontColor
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.valueLabel.textColor = ColorUtils.fontColor
        self.valueLabel.textAlignment = .left
        self.valueLabel.font = UIFont.systemFont(ofSize: 14)
        self.valueLabel.padding = UIEdgeInsets.zero
        self.errorImageView.image = UIImage(named: "error")
    }
}
