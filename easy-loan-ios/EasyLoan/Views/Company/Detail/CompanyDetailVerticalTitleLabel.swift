import UIKit
import SnapKit

class CompanyDetailVerticalTitleLabel: UIView {

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var value: String? {
        didSet {
            valueLabel.text = value
        }
    }

    fileprivate let titleLabel = UILabel()
    fileprivate let valueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    override func updateConstraints() {
        super.updateConstraints()
        self.titleLabel.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(12)
        }
        self.valueLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            make.height.equalTo(14)
        }
    }

    fileprivate func initViews() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.titleLabel.textColor = ColorUtils.fontColor
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(self.titleLabel)

        self.valueLabel.font = UIFont.systemFont(ofSize: 14)
        self.valueLabel.textColor = ColorUtils.fontColor
        self.valueLabel.textAlignment = NSTextAlignment.center
        self.addSubview(self.valueLabel)
    }
}
