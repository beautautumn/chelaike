import UIKit
import SnapKit

class CompanyDetailShopItemView: UIView {

    var isHeader: Bool = false {
        didSet {
            if isHeader {
                self.leftLabel.textColor = ColorUtils.doveGrayColor
                self.rightLabel.textColor = ColorUtils.doveGrayColor
                self.separator.backgroundColor = UIColor.white
                self.backgroundColor = ColorUtils.separatorColor
            } else {
                self.leftLabel.textColor = ColorUtils.fontColor
                self.rightLabel.textColor = ColorUtils.fontColor
                self.separator.backgroundColor = ColorUtils.separatorColor
                self.backgroundColor = UIColor.white
            }
        }
    }

    var leftText: String? {
        didSet {
            leftLabel.text = leftText
        }
    }

    var rightText: String? {
        didSet {
            rightLabel.text = rightText
        }
    }

    fileprivate let leftLabel = UILabel()
    fileprivate let separator = UIView()
    fileprivate let rightLabel = UILabel()
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
        self.leftLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self.snp.centerX).offset(-1)
            make.top.bottom.equalTo(self)
        }
        self.separator.snp.remakeConstraints { (make) in
            make.left.equalTo(self.leftLabel.snp.right)
            make.width.equalTo(1)
            make.top.bottom.equalTo(self)
        }
        self.rightLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.separator.snp.right)
            make.right.top.bottom.equalTo(self)
        }
        self.borderBottom.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.snp.bottom).offset(-1)
            make.height.equalTo(1)
        }
    }

    fileprivate func initViews() {
        self.backgroundColor = UIColor.white

        self.leftLabel.textColor = ColorUtils.fontColor
        self.leftLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(self.leftLabel)

        self.separator.backgroundColor = ColorUtils.separatorColor
        self.addSubview(self.separator)

        self.rightLabel.textColor = ColorUtils.fontColor
        self.rightLabel.font = UIFont.systemFont(ofSize: 12)
        self.rightLabel.textAlignment = .center
        self.addSubview(self.rightLabel)

        self.borderBottom.backgroundColor = ColorUtils.separatorColor
        self.addSubview(self.borderBottom)
    }
}
