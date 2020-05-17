import UIKit
import SnapKit

class UserPhoneView: UIView {

    var name: String? {
        didSet {
            self.nameLabel.text = self.name
        }
    }

    var phone: String? {
        didSet {
            self.phoneNumberLabel.text = self.phone
        }
    }

    fileprivate let nameLabel = UILabel()
    fileprivate let phoneImageView = UIImageView()
    fileprivate let phoneNumberLabel = UILabel()

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
        self.updateNameLabelConstraints(self.nameLabel)
        self.phoneImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.nameLabel.snp.right).offset(4)
            make.centerY.equalTo(self)
            make.size.equalTo(12)
        }
        self.phoneNumberLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.phoneImageView.snp.right).offset(1)
            make.width.equalTo(self.phone?.size(self.phoneNumberLabel.font).width ?? 81)
            make.top.bottom.equalTo(self)
        }
    }

    func updateNameLabelConstraints(_ nameLabel: UILabel) {
        nameLabel.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(self.name?.size(nameLabel.font).width ?? 36)
        }
    }

    fileprivate func initViews() {
        self.nameLabel.font = UIFont.systemFont(ofSize: 12)
        self.nameLabel.textColor = ColorUtils.grayTextColor
        self.addSubview(self.nameLabel)
        
        self.phoneImageView.image = UIImage(named: "phone")
        self.addSubview(self.phoneImageView)
        
        self.phoneNumberLabel.font = UIFont.systemFont(ofSize: 12)
        self.phoneNumberLabel.textColor = ColorUtils.primaryColor
        self.addSubview(self.phoneNumberLabel)
        
        self.phoneNumberLabel.isUserInteractionEnabled = true
        self.phoneNumberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
    }

    @objc func onClicked() {
        if self.phone?.isEmpty ?? true {
            return
        }
        if let url = URL(string: "tel:\(self.phone!)") {
            UIApplication.shared.openURL(url)
        }
    }
}
