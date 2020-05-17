import UIKit
import SnapKit
import ZMKnife
import Kingfisher

class CarItemView: BorderBottomView {

    var cover: String? {
        didSet {
            if let url = cover {
                coverImageView.kf.setImage(with: URL(string: ImageUtils.scalePath(url, width: 70, height: 52)),
                                           placeholder: UIImage(named: "default_car"))
            } else {
                coverImageView.image = UIImage(named: "default_car")
            }
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.name = name
        }
    }
    
    var vin: String? {
        didSet {
            setVinAndStateLabelValue()
        }
    }
    
    var showPrice: String? {
        didSet {
            setPriceValue()
        }
    }
    
    var estimatePrice: String? {
        didSet {
            setPriceValue()
            setVinAndStateLabelValue()
        }
    }
    
    var isShowLeftTag: Bool = false {
        didSet {
            setTagImage()
        }
    }
    
    var isOriginalCar: Bool = false {
        didSet {
            setTagImage()
        }
    }
    
    var isNewCar: Bool = false {
        didSet {
            setTagImage()
        }
    }
    
    fileprivate let coverImageView = UIImageView()
    fileprivate let nameLabel = CarItemNameLabel()
    fileprivate let vinAndStateLabel = UILabel()
    fileprivate let priceLabel = CarItemPriceLabel()
    fileprivate let tagImageView = UIImageView()
    
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
        self.coverImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(70)
            make.top.equalTo(self).offset(8)
            make.height.equalTo(52)
        }
        self.nameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(6)
            make.right.equalTo(self).offset(-12)
            make.top.equalTo(self).offset(5)
            make.height.greaterThanOrEqualTo(17)
        }
        self.vinAndStateLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(6)
            make.width.equalTo(self).multipliedBy(0.48)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.height.greaterThanOrEqualTo(12)
        }
        self.priceLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.vinAndStateLabel.snp.right)
            make.right.equalTo(self).offset(-12)
            make.bottom.equalTo(self).offset(-10)
            make.height.greaterThanOrEqualTo(16)
        }
        self.tagImageView.snp.remakeConstraints { (make) in
            make.top.right.equalTo(self)
            make.size.equalTo(40)
        }
    }
    
    override func initViews() {
        self.backgroundColor = UIColor.white

        self.coverImageView.image = UIImage(named: "default_car")
        self.vinAndStateLabel.textColor = ColorUtils.grayTextColor
        self.vinAndStateLabel.font = UIFont.systemFont(ofSize: 10)
        self.vinAndStateLabel.numberOfLines = 2

        self.addSubview(self.coverImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.vinAndStateLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.tagImageView)
        super.initViews()
    }

    fileprivate func setPriceValue() {
        if self.estimatePrice?.isEmpty ?? true {
            self.priceLabel.title = "标价"
            self.priceLabel.price = self.showPrice
        } else {
            self.priceLabel.title = "估值"
            self.priceLabel.price = self.estimatePrice
        }
    }
    
    fileprivate func setVinAndStateLabelValue() {
        if self.estimatePrice?.isEmpty ?? true {
            self.vinAndStateLabel.text = "车架号：\(self.vin ?? "") / 未评估"
        } else {
            self.vinAndStateLabel.text = "车架号：\(self.vin ?? "") / 已评估"
        }
    }

    fileprivate func setTagImage() {
        if self.isShowLeftTag {
            self.tagImageView.image = nil
            if self.isNewCar {
                self.nameLabel.tagType = "circle_new_car"
            } else if self.isOriginalCar {
                self.nameLabel.tagType = "circle_original_car"
            } else {
                self.nameLabel.tagType = nil
            }
            
        } else {
            self.nameLabel.tagType = nil
            if self.isNewCar {
                self.tagImageView.image = UIImage(named: "new_car")
            } else if self.isOriginalCar {
                self.tagImageView.image = UIImage(named: "original_car")
            } else {
                self.tagImageView.image = nil
            }
        }
    }
}
