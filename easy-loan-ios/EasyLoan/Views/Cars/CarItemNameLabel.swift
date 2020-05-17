import UIKit

class CarItemNameLabel: UIView {

    var tagType: String? {
        didSet {
            if tagType == nil {
                tagImageView.image = nil
                tagImageView.removeFromSuperview()
            } else {
                tagImageView.image = UIImage(named: tagType!)
                insertSubview(tagImageView, at: 0)
            }
            updateConstraintsIfNeeded()
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }

    fileprivate var nameLabel = UILabel()
    fileprivate var tagImageView = UIImageView()

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
        if self.subviews.count == 2 {
            self.tagImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(self)
                make.top.equalTo(self).offset(3)
                make.size.equalTo(14)
            }
            self.nameLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(self.tagImageView.snp.right).offset(6)
                make.top.bottom.right.equalTo(self)
            }
        } else {
            self.nameLabel.snp.remakeConstraints { (make) in
                make.left.right.top.bottom.equalTo(self)
            }
        }
    }

    fileprivate func initViews() {
        self.nameLabel.numberOfLines = 2
        self.nameLabel.textColor = UIColor.black
        self.nameLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(self.nameLabel)
    }
}
