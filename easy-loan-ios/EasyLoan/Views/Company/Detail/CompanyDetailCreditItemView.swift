import UIKit
import SnapKit

class CompanyDetailCreditItemView: UIView {

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var currentCreditAndLimitAmount: String? {
        didSet {
            currentCreditAndLimitAmountLabel.value = currentCreditAndLimitAmount
        }
    }

    var inUseAmount: String? {
        didSet {
            inUseAmountLabel.value = inUseAmount
        }
    }

    var unusedAmount: String? {
        didSet {
            unusedAmountLabel.value = unusedAmount
        }
    }

    var allowPartRepay: Bool = false {
        didSet {
            allowPartRepayLabel.value = allowPartRepay ? "是" : "否"
        }
    }

    fileprivate let titleLabel = UILabel()
    fileprivate let currentCreditAndLimitAmountLabel = CompanyDetailTitleValueLabel()
    fileprivate let inUseAmountLabel = CompanyDetailTitleValueLabel()
    fileprivate let unusedAmountLabel = CompanyDetailTitleValueLabel()
    fileprivate let allowPartRepayLabel = CompanyDetailTitleValueLabel()

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
            make.height.equalTo(41)
        }
        self.currentCreditAndLimitAmountLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.height.equalTo(41)
        }
        self.inUseAmountLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.currentCreditAndLimitAmountLabel.snp.bottom)
            make.height.equalTo(41)
        }
        self.unusedAmountLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.inUseAmountLabel.snp.bottom)
            make.height.equalTo(41)
        }
        self.allowPartRepayLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.unusedAmountLabel.snp.bottom)
            make.height.equalTo(41)
        }
    }

    fileprivate func initViews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorUtils.separatorColor.cgColor
        self.layer.cornerRadius = 4
        self.clipsToBounds = true

        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = ColorUtils.doveGrayColor
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.backgroundColor = ColorUtils.separatorColor
        self.addSubview(self.titleLabel)

        self.currentCreditAndLimitAmountLabel.title = "当前授信/最大授信"
        self.addSubview(self.currentCreditAndLimitAmountLabel)

        self.inUseAmountLabel.title = "当前用款"
        self.addSubview(self.inUseAmountLabel)

        self.unusedAmountLabel.title = "未用授信"
        self.addSubview(self.unusedAmountLabel)

        self.allowPartRepayLabel.title = "允许部分还款"
        self.addSubview(allowPartRepayLabel)
    }
}
