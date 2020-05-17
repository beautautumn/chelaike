import UIKit
import SnapKit

class CompanyDetailTitleValueLabel : UIView {

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
    fileprivate let borderBottom = UIView()

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
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self.snp.centerX)
            make.top.bottom.equalTo(self)
        }
        self.valueLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp.right)
            make.right.equalTo(self).offset(-16)
            make.top.bottom.equalTo(self)
        }
        self.borderBottom.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.snp.bottom).offset(-1)
            make.height.equalTo(1)
        }
    }

    fileprivate func initViews() {
        self.titleLabel.textColor = ColorUtils.fontColor
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.titleLabel)

        self.valueLabel.textColor = ColorUtils.fontColor
        self.valueLabel.textAlignment = .right
        self.valueLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.valueLabel)

        self.borderBottom.backgroundColor = ColorUtils.separatorColor
        self.addSubview(self.borderBottom)
    }
}
