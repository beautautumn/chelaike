import UIKit
import SnapKit

class MessageTableViewCell: UITableViewCell {
    
    fileprivate let dateTimeLabel = UILabel()
    fileprivate let stateLabel = UILabel()
    fileprivate let applyCodeLabel = UILabel()
    fileprivate let companyLabel = UILabel()
    fileprivate let contentLabel = VerticalTopLabel()
    
    fileprivate let messageInfoPanel = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initContentViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initContentViews()
    }
    
    func initContentViews() {
        self.contentView.backgroundColor = ColorUtils.separatorColor
        self.dateTimeLabel.textColor = UIColor.white
        self.dateTimeLabel.font = UIFont.systemFont(ofSize: 10)
        self.dateTimeLabel.backgroundColor = UIColor.lightGray
        self.dateTimeLabel.textAlignment = NSTextAlignment.center
        self.dateTimeLabel.clipsToBounds = true
        self.dateTimeLabel.layer.cornerRadius = 4
        self.contentView.addSubview(self.dateTimeLabel)
        self.dateTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(14)
            make.height.equalTo(16)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(95)
        }
        
        self.messageInfoPanel.backgroundColor = UIColor.white
        self.messageInfoPanel.clipsToBounds = true
        self.messageInfoPanel.layer.cornerRadius = 6
        self.contentView.addSubview(self.messageInfoPanel)
        self.messageInfoPanel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateTimeLabel.snp.bottom).offset(10)
            make.height.equalTo(96)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
        }
        
        self.stateLabel.textColor = UIColor.black
        self.stateLabel.font = UIFont.systemFont(ofSize: 14)
        self.messageInfoPanel.addSubview(self.stateLabel)
        self.stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageInfoPanel).offset(10)
            make.height.equalTo(14)
            make.left.equalTo(self.messageInfoPanel).offset(10)
            make.right.equalTo(self.messageInfoPanel.snp.centerX)
        }
        
        self.applyCodeLabel.textColor = UIColor.lightGray
        self.applyCodeLabel.font = UIFont.systemFont(ofSize: 10)
        self.applyCodeLabel.textAlignment = NSTextAlignment.right
        self.messageInfoPanel.addSubview(self.applyCodeLabel)
        self.applyCodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageInfoPanel).offset(10)
            make.height.equalTo(10)
            make.left.equalTo(self.messageInfoPanel.snp.centerX)
            make.right.equalTo(self.messageInfoPanel).offset(-10)
        }
        
        self.messageInfoPanel.addSubview(self.companyLabel)
        self.companyLabel.font = UIFont.systemFont(ofSize: 12)
        self.companyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.messageInfoPanel).offset(10)
            make.right.equalTo(self.messageInfoPanel).offset(-10)
            make.top.equalTo(self.stateLabel.snp.bottom).offset(10)
            make.height.equalTo(12)
        }
        
        self.contentLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentLabel.numberOfLines = 2
        self.messageInfoPanel.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.messageInfoPanel).offset(10)
            make.right.equalTo(self.messageInfoPanel).offset(-10)
            make.top.equalTo(self.companyLabel.snp.bottom).offset(5)
            make.height.equalTo(33)
        }
    }
    
    func reloadData(_ data: AnyObject) {
        self.dateTimeLabel.text = "\(data["createTime"] as! String)"
        self.stateLabel.text = "\(data["operationRecordType"] as! String)"
        self.applyCodeLabel.text = "申请编号： \(data["applyCode"] as! String)"
        self.companyLabel.text = "\(data["shopName"] as! String)"
        if let message = data["message"] as? String {
            self.contentLabel.text = "\(message)"
        }
    }
}
