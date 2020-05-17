import UIKit
import SpriteKit

class StatisticsNewLocationView: DynamicTitleAndValueTextView {
    
    open var onClickedListener: (() -> Void)?

    override var value: String? {
        didSet {
            self.refreshLabel.isHidden = self.value?.isEmpty ?? true
        }
    }

    fileprivate let refreshLabel = UILabel()
    
    override func initViews() {
        super.initViews()
        self.refreshLabel.isHidden = true
        self.refreshLabel.text = "刷新"
        self.refreshLabel.textColor = ColorUtils.blueTextColor
        self.refreshLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.refreshLabel)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
    }
    
    override func calculateValueLabelSpace() -> CGFloat {
        return super.calculateValueLabelSpace() + 60
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.refreshLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-self.rightPadding)
            make.width.equalTo(31)
            make.top.equalTo(self).offset(self.valueLabel.padding.top)
            make.bottom.equalTo(self).offset(-self.valueLabel.padding.bottom)
        }
    }

    override func updateValueLabelConstraints() {
        self.valueLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right)
            make.right.equalTo(self).offset(-(self.rightPadding + 60))
            make.top.equalTo(self).offset(self.valueLabel.padding.top)
            make.bottom.equalTo(self).offset(-self.valueLabel.padding.bottom)
        }
    }

    @objc open func onClicked() {
        if self.value?.isEmpty ?? true {
            return
        }
        if let callback = self.onClickedListener {
            callback()
        }
    }
}
