import UIKit
import SnapKit
import Kingfisher

class CompanyDetailBasicView: UIView {

    fileprivate let coverImageView = UIImageView()
    fileprivate let nameLabel = UILabel()
    fileprivate let userPhoneNumberView = CompanyDetailUserPhoneView()
    fileprivate let addressLabel = UILabel()
    fileprivate let assigneeLabel = UILabel()
    fileprivate let singleCarRateLabel = CompanyDetailVerticalTitleLabel()
    fileprivate let currentCreditAmountLabel = CompanyDetailVerticalTitleLabel()
    fileprivate let limitAmountLabel = CompanyDetailVerticalTitleLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    func reloadData(_ data: [String: AnyObject]) {
        if (data["logo"] as? String)?.isEmpty ?? true {
            self.coverImageView.image = UIImage(named: "company_default_avatar")
        } else {
            self.coverImageView.kf.setImage(with: URL(string: ImageUtils.scalePath(data["logo"] as! String, width: 50, height: 50)),
                                            placeholder: UIImage(named: "company_default_avatar"))
        }
        self.nameLabel.text = data["name"] as? String
        self.addressLabel.text = data["address"] as? String
        self.userPhoneNumberView.name = data["contactName"] as? String
        self.userPhoneNumberView.phone = data["contactPhone"] as? String
        self.assigneeLabel.text = "归属业务员：\(data["assigneeName"] as! String)"
        self.singleCarRateLabel.value = "\(data["singleCarRate"] as! String)%"
        self.currentCreditAmountLabel.value = "\(data["totalCurrentCreditWan"] as! String)万"
        self.limitAmountLabel.value = "\(data["totalLimitCreditWan"] as! String)万"

        self.snp.remakeConstraints { (make) in
            make.height.equalTo(236)
        }
        self.coverImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(19.5)
            make.centerX.equalTo(self)
            make.size.equalTo(50)
        }
        self.nameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self.coverImageView.snp.bottom).offset(20)
            make.height.equalTo(16)
        }
        self.userPhoneNumberView.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8)
            make.height.equalTo(16)
        }
        self.addressLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self.userPhoneNumberView.snp.bottom).offset(6)
            make.height.equalTo(16)
        }
        self.assigneeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self.addressLabel.snp.bottom).offset(10)
            make.height.equalTo(12)
        }
        self.singleCarRateLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.33)
            make.top.equalTo(self.assigneeLabel.snp.bottom).offset(20)
            make.height.equalTo(34)
        }
        self.currentCreditAmountLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.singleCarRateLabel.snp.right)
            make.width.equalTo(self).multipliedBy(0.33)
            make.top.equalTo(self.assigneeLabel.snp.bottom).offset(20)
            make.height.equalTo(34)
        }
        self.limitAmountLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.currentCreditAmountLabel.snp.right)
            make.width.equalTo(self).multipliedBy(0.33)
            make.top.equalTo(self.assigneeLabel.snp.bottom).offset(20)
            make.height.equalTo(34)
        }
    }

    fileprivate func initViews() {
        self.backgroundColor = UIColor.white
        self.coverImageView.image = UIImage(named: "company_default_avatar")
        self.addSubview(self.coverImageView)

        self.nameLabel.font = UIFont.systemFont(ofSize: 16)
        self.nameLabel.textAlignment = NSTextAlignment.center
        self.addSubview(self.nameLabel)

        self.addSubview(self.userPhoneNumberView)

        self.addressLabel.font = UIFont.systemFont(ofSize: 12)
        self.addressLabel.textAlignment = NSTextAlignment.center
        self.addressLabel.textColor = ColorUtils.grayTextColor
        self.addSubview(self.addressLabel)

        self.assigneeLabel.font = UIFont.systemFont(ofSize: 12)
        self.assigneeLabel.textAlignment = NSTextAlignment.center
        self.assigneeLabel.textColor = ColorUtils.grayTextColor
        self.addSubview(self.assigneeLabel)

        self.singleCarRateLabel.title = "单车借款比例"
        self.addSubview(self.singleCarRateLabel)

        self.currentCreditAmountLabel.title = "当前授信"
        self.addSubview(self.currentCreditAmountLabel)

        self.limitAmountLabel.title = "最大授信"
        self.addSubview(self.limitAmountLabel)
    }
}
