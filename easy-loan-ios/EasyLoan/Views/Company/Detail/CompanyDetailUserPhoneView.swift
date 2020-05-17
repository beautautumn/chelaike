import UIKit
import SnapKit

class CompanyDetailUserPhoneView: UserPhoneView {

    override func updateNameLabelConstraints(_ nameLabel: UILabel) {
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .right
        nameLabel.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(self.snp.centerX).offset(-30)
        }
    }
}
