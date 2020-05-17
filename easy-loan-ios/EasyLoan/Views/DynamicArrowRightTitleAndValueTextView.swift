import UIKit
import SnapKit

class DynamicArrowRightTitleAndValueTextView: DynamicTitleAndValueTextView {

    open var onClickedListener: (() -> Void)?

    fileprivate let rightIconImageView = UIImageView()

    open override func updateConstraints() {
        super.updateConstraints()
        self.rightIconImageView.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-self.rightPadding)
            make.width.equalTo(6)
            make.centerY.equalTo(self)
            make.height.equalTo(12)
        }
    }
    
    open override func updateValueLabelConstraints() {
        self.valueLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right)
            make.right.equalTo(self).offset(-(self.rightPadding + 10))
            make.top.equalTo(self).offset(self.valueLabel.padding.top)
            make.bottom.equalTo(self).offset(-self.valueLabel.padding.bottom)
        }
    }
    
    open override func initViews() {
        super.initViews()
        self.rightIconImageView.image = UIImage(named: "arrow_right")
        self.addSubview(self.rightIconImageView)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
    }
    
    @objc open func onClicked() {
        if let callback = self.onClickedListener {
            callback()
        }
    }
}
