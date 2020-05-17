import UIKit
import SnapKit
import Kingfisher

class CompanyTableViewCell: UITableViewCell {

    fileprivate let coverImageView = UIImageView()
    fileprivate let nameLabel = UILabel()
    fileprivate let assigneeLabel = UILabel()
    fileprivate let totalCurrentCreditLabel = UILabel()
    fileprivate let statisticsLabel = UILabel()
    fileprivate let totalLimitAmount = UILabel()
    fileprivate let borderBottom = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    fileprivate func initViews() {
        self.contentView.backgroundColor = UIColor.white

        self.coverImageView.layer.cornerRadius = 4
        self.coverImageView.clipsToBounds = true
        self.contentView.addSubview(self.coverImageView)
        self.coverImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(10)
            make.size.equalTo(50)
        }

        self.nameLabel.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(12)
            make.height.equalTo(14)
        }

        self.assigneeLabel.font = UIFont.systemFont(ofSize: 10)
        self.assigneeLabel.textColor = ColorUtils.grayTextColor
        self.contentView.addSubview(self.assigneeLabel)
        self.assigneeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(10)
            make.width.equalTo(self.contentView).multipliedBy(0.5)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.height.equalTo(10)
        }
        self.totalCurrentCreditLabel.font = UIFont.systemFont(ofSize: 10)
        self.totalCurrentCreditLabel.textColor = ColorUtils.grayTextColor
        self.contentView.addSubview(self.totalCurrentCreditLabel)
        self.totalCurrentCreditLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(10)
            make.width.equalTo(self.contentView).multipliedBy(0.5)
            make.top.equalTo(self.assigneeLabel.snp.bottom).offset(6)
            make.height.equalTo(10)
        }

        self.statisticsLabel.font = UIFont.systemFont(ofSize: 10)
        self.statisticsLabel.textColor = ColorUtils.grayTextColor
        self.contentView.addSubview(self.statisticsLabel)
        self.statisticsLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.width.equalTo(self.contentView).multipliedBy(0.3)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.height.equalTo(10)
        }
        self.totalLimitAmount.font = UIFont.systemFont(ofSize: 10)
        self.totalLimitAmount.textColor = ColorUtils.grayTextColor
        self.contentView.addSubview(self.totalLimitAmount)
        self.totalLimitAmount.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.width.equalTo(self.contentView).multipliedBy(0.3)
            make.top.equalTo(self.statisticsLabel.snp.bottom).offset(6)
            make.height.equalTo(10)
        }

        self.borderBottom.backgroundColor = ColorUtils.separatorColor
        self.contentView.addSubview(self.borderBottom)
        self.borderBottom.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(1)
        }
    }

    func reloadData(_ data: [String: AnyObject]) {
        if (data["logo"] as? String)?.isEmpty ?? true {
            self.coverImageView.image = UIImage(named: "company_default_avatar")
        } else {
            self.coverImageView.kf.setImage(with: URL(string: ImageUtils.scalePath(data["logo"] as! String, width: 50, height: 50)),
                                       placeholder: UIImage(named: "company_default_avatar"))
        }
        self.nameLabel.text = data["name"] as? String
        self.assigneeLabel.text = "归属业务员：\(data["assigneeName"] as! String)"
        self.totalCurrentCreditLabel.text = "当前总授信：\(data["totalCurrentCreditWan"] as! String)万"
        self.statisticsLabel.text = "盘库员：\((data["inventoryUserName"] as! [String]).joined(separator: "，"))"
        self.totalLimitAmount.text = "最大总授信：\(data["totalLimitCreditWan"] as! String)万"
    }
}
