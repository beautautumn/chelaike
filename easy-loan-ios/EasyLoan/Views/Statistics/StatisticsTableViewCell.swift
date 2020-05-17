import UIKit
import SnapKit
import Kingfisher

class StatisticsTableViewCell: UITableViewCell {
    
    fileprivate let applyCodeLabel = UILabel()
    fileprivate let dateLabel = UILabel()
    
    fileprivate let coverImageView = UIImageView()
    fileprivate let nameLabel = UILabel()
    fileprivate let startTimeLabel = UILabel()
    fileprivate let countLabel = UILabel()
    fileprivate let statisticsStateLabel = UILabel()
    fileprivate let positionStateLabel = UILabel()
    fileprivate let statisticsUserLabel = UILabel()
    
    
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
        
        self.applyCodeLabel.font = UIFont.systemFont(ofSize: 10)
        self.applyCodeLabel.textColor = ColorUtils.grayTextColor
        self.contentView.addSubview(self.applyCodeLabel)
        self.applyCodeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(7)
            make.right.equalTo(self.contentView.snp.centerX)
            make.height.equalTo(10)
        }
        
        self.dateLabel.font = UIFont.systemFont(ofSize: 10)
        self.dateLabel.textColor = ColorUtils.grayTextColor
        self.dateLabel.textAlignment = .right
        self.contentView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.applyCodeLabel.snp.right)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(7)
            make.height.equalTo(10)
        }
        
        self.contentView.addSubview(self.coverImageView)
        self.coverImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.applyCodeLabel.snp.bottom).offset(7)
            make.size.equalTo(50)
        }
        
        self.nameLabel.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.applyCodeLabel.snp.bottom).offset(7)
            make.height.equalTo(14)
        }
        
        self.startTimeLabel.font = UIFont.systemFont(ofSize: 10)
        self.startTimeLabel.textColor = ColorUtils.grayTextColor
        self.contentView.addSubview(self.startTimeLabel)
        self.startTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.centerX)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.height.equalTo(10)
        }
        self.countLabel.font = UIFont.systemFont(ofSize: 10)
        self.countLabel.textColor = ColorUtils.grayTextColor
        self.contentView.addSubview(self.countLabel)
        self.countLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.centerX)
            make.top.equalTo(self.startTimeLabel.snp.bottom).offset(6)
            make.height.equalTo(10)
        }
        
        self.statisticsStateLabel.font = UIFont.systemFont(ofSize: 10)
        self.statisticsStateLabel.textColor = UIColor.white
        self.statisticsStateLabel.textAlignment = NSTextAlignment.right
        self.statisticsStateLabel.backgroundColor = ColorUtils.greenTextColor
        self.contentView.addSubview(self.statisticsStateLabel)
        self.statisticsStateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.height.equalTo(14)
        }
        
        self.positionStateLabel.font = UIFont.systemFont(ofSize: 10)
        self.positionStateLabel.textColor = UIColor.white
        self.positionStateLabel.textAlignment = NSTextAlignment.right
        self.positionStateLabel.backgroundColor = ColorUtils.redTextColor
        self.contentView.addSubview(self.positionStateLabel)
        self.positionStateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.statisticsStateLabel.snp.left).offset(-5)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.height.equalTo(14)
        }
        
        self.statisticsUserLabel.font = UIFont.systemFont(ofSize: 10)
        self.statisticsUserLabel.textColor = ColorUtils.grayTextColor
        self.statisticsUserLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(self.statisticsUserLabel)
        self.statisticsUserLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.centerX)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.statisticsStateLabel.snp.bottom).offset(6)
            make.height.equalTo(10)
        }
        self.setBottomBorder()
    }
    
    func reloadData(_ data: [String: AnyObject]) {
        self.applyCodeLabel.text = "编号：\(data["inventoryCode"] as! String)"
        self.dateLabel.text = "\(data["inventoryStartTimeDay"] as! String)"
        self.nameLabel.text = "\(data["storeName"] as! String)"
        self.startTimeLabel.text = "盘库开始：\(data["inventoryStartTimeMinute"] as! String)"
        self.statisticsUserLabel.text = "盘库员：\(data["userName"] as! String)"
        if let countInventoryCars = data["countInventoryCars"] as? Int {
            self.countLabel.text = "盘库数量：\(countInventoryCars)辆"
        } else {
            self.countLabel.text = "盘库数量：0辆"
        }
        if (data["debtorImageUrl"] as? String)?.isEmpty ?? true {
            self.coverImageView.image = UIImage(named: "company_default_avatar")
        } else {
            self.coverImageView.kf.setImage(with: URL(string: ImageUtils.scalePath(data["debtorImageUrl"] as! String, width: 50, height: 50)),
                                            placeholder: UIImage(named: "company_default_avatar"))
        }
        if (data["positioningAbnormal"] as? Bool)! {
            self.positionStateLabel.text = "定位异常"
        } else {
            self.positionStateLabel.text = ""
        }
        if (data["timeout"] as? Bool)! {
            self.statisticsStateLabel.text = "超时"
            self.statisticsStateLabel.backgroundColor = ColorUtils.primaryColor
        } else {
            self.statisticsStateLabel.text = ""
        }
        if let isDoing = data["isDoing"] as? Bool {
            if isDoing {
                self.statisticsStateLabel.text = "进行中"
                self.statisticsStateLabel.backgroundColor = ColorUtils.lightOrangeTextColor
            } else {
                if !(data["positioningAbnormal"] as? Bool)! && !(data["timeout"] as? Bool)! {
                    self.statisticsStateLabel.text = "正常"
                    self.statisticsStateLabel.backgroundColor = ColorUtils.greenTextColor
                } else {
                    self.statisticsStateLabel.text = ""
                    self.statisticsStateLabel.backgroundColor = UIColor.clear
                }
            }
        }
    }
}
