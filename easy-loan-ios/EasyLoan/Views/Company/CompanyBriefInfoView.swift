import UIKit
import ZMKnife
import SnapKit

class CompanyBriefInfoView: BorderBottomView {

    var name: String? {
        didSet {
            self.nameLabel.text = self.name
        }
    }

    var userName: String? {
        didSet {
            self.phoneNumberView.name = self.userName
        }
    }

    var phoneNumber: String? {
        didSet {
            self.phoneNumberView.phone = self.phoneNumber
        }
    }

    var address: String? {
        didSet {
            self.addressLabel.text = "地址：\(self.address ?? "-")"
        }
    }
    
    var onClickedListener: (() -> Void)?

    fileprivate let nameLabel = UILabel()
    fileprivate let phoneNumberView = UserPhoneView()
    fileprivate let addressLabel = UILabel()
    fileprivate let arrowRightImageView = UIImageView()

    override func updateConstraints() {
        super.updateConstraints()
        self.nameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(8)
            make.height.equalTo(16)
        }
        self.phoneNumberView.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(4)
            make.height.greaterThanOrEqualTo(16)
        }
        self.addressLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self.phoneNumberView.snp.bottom).offset(2)
            make.bottom.equalTo(self).offset(-8)
        }
        self.arrowRightImageView.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(6)
            make.centerY.equalTo(self)
            make.height.equalTo(12)
        }
    }
    
    override func initViews() {
        self.backgroundColor = UIColor.white
        self.nameLabel.textColor = ColorUtils.fontColor
        self.nameLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.nameLabel)
        
        self.addSubview(self.phoneNumberView)
        
        self.addressLabel.textColor = ColorUtils.grayTextColor
        self.addressLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(self.addressLabel)

        self.arrowRightImageView.image = UIImage(named: "arrow_right")
        self.addSubview(self.arrowRightImageView)
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))

        super.initViews()
    }

    @objc open func onClicked() {
        if let callback = self.onClickedListener {
            callback()
        }
    }
}
