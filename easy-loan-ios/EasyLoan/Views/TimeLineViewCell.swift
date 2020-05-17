import UIKit

class TimeLineViewCell : UIView {
    
    var height: CGFloat {
        return self.calculateHeight()
    }
    
    var textColor: UIColor = ColorUtils.grayTextColor {
        didSet {
            self.updateLabelColors()
        }
    }

    var clickable: Bool = false {
        didSet {
            self.updateShowDetailView()
        }
    }

    var title: String? {
        didSet {
            self.titleLabel.text = title?.trimmingCharacters(in: .whitespaces)
        }
    }

    var content: String? {
        didSet {
            self.contentLabel.text = content?.trimmingCharacters(in: .whitespaces)
        }
    }

    var userName: String? {
        didSet {
            self.userNameLabel.text = "操作员：\(userName?.trimmingCharacters(in: .whitespaces) ?? "-")"
        }
    }

    var date: String? {
        didSet {
            self.dateLabel.text = date?.trimmingCharacters(in: .whitespaces)
        }
    }

    fileprivate let titleLabel = UILabel()
    fileprivate let contentLabel = UILabel()

    fileprivate let footerView = UIView()
    fileprivate let userNameLabel = UILabel()
    fileprivate let dateLabel = UILabel()
    fileprivate let showDetailLabel = UILabel()
    fileprivate let arrowRightImageView = UIImageView()

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
            make.left.equalTo(self).offset(7)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.greaterThanOrEqualTo(0)
        }
        self.contentLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(7)
            make.right.equalTo(self)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            make.height.greaterThanOrEqualTo(0)
        }

        self.footerView.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(7)
            make.right.equalTo(self)
            make.top.equalTo(self.contentLabel.snp.bottom).offset(8)
            make.height.equalTo(12)
        }
        self.userNameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.footerView)
            make.width.equalTo(self.footerView).multipliedBy(0.33)
            make.top.equalTo(self.footerView).offset(1)
            make.height.equalTo(10)
        }
        self.dateLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.userNameLabel.snp.right).offset(2)
            make.width.equalTo(self.footerView).multipliedBy(0.33)
            make.top.equalTo(self.footerView).offset(1)
            make.height.equalTo(10)
        }
        self.showDetailLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.dateLabel.snp.right).offset(2)
            make.right.equalTo(self.footerView).offset(-10)
            make.top.bottom.equalTo(self.footerView)
        }
        self.arrowRightImageView.snp.remakeConstraints { (make) in
            make.right.centerY.equalTo(self.footerView)
            make.width.equalTo(7)
            make.height.equalTo(12)
        }
    }
    
    fileprivate func initViews() {
        self.backgroundColor = UIColor.white
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(self.titleLabel)

        self.contentLabel.numberOfLines = 0
        self.contentLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(self.contentLabel)

        self.addSubview(self.footerView)

        self.userNameLabel.font = UIFont.systemFont(ofSize: 10)
        self.footerView.addSubview(self.userNameLabel)

        self.dateLabel.font = UIFont.systemFont(ofSize: 10)
        self.footerView.addSubview(self.dateLabel)

        self.showDetailLabel.text = "查看详情"
        self.showDetailLabel.textAlignment = .right
        self.showDetailLabel.font = UIFont.systemFont(ofSize: 12)
        self.showDetailLabel.textColor = ColorUtils.grayTextColor
        self.footerView.addSubview(self.showDetailLabel)

        self.arrowRightImageView.image = UIImage(named: "arrow_right")
        self.footerView.addSubview(self.arrowRightImageView)

        self.updateLabelColors()
        self.updateShowDetailView()
    }

    fileprivate func updateLabelColors() {
        self.titleLabel.textColor = self.textColor
        self.contentLabel.textColor = self.textColor
        self.userNameLabel.textColor = self.textColor
        self.dateLabel.textColor = self.textColor
    }

    fileprivate func updateShowDetailView() {
        if self.clickable {
            self.showDetailLabel.isHidden = false
            self.arrowRightImageView.isHidden = false
        } else {
            self.showDetailLabel.isHidden = true
            self.arrowRightImageView.isHidden = true
        }
    }

    fileprivate func calculateHeight() -> CGFloat {
        let constraint = CGSize(width: UIScreen.main.bounds.width - 56, height: CGFloat.greatestFiniteMagnitude)
        let titleHeight = self.title?.size(self.titleLabel.font, constraint: constraint).height ?? 12
        let contentHeight = self.content?.size(self.contentLabel.font, constraint: constraint).height ?? 12
        return titleHeight + contentHeight + 26
    }
}
