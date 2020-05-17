import UIKit
import ZMKnife
import SnapKit

class LoanDetailPriceView: BorderBottomView {
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    var price: String? {
        didSet {
            self.priceLabel.text = self.price
        }
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let priceLabel = UILabel()
    fileprivate let unitLabel = UILabel()
    
    override func updateConstraints() {
        super.updateConstraints()
        self.unitLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.width.greaterThanOrEqualTo(0)
            make.top.bottom.equalTo(self)
        }
        self.priceLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self.unitLabel.snp.left)
            make.width.greaterThanOrEqualTo(0)
            make.top.bottom.equalTo(self)
        }
        self.titleLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self.priceLabel.snp.left)
            make.width.greaterThanOrEqualTo(0)
            make.top.bottom.equalTo(self)
        }
    }
    
    override func initViews() {
        self.backgroundColor = UIColor.white
        self.titleLabel.textColor = ColorUtils.orangeTextColor
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.titleLabel)
        
        self.priceLabel.textColor = ColorUtils.orangeTextColor
        self.priceLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(self.priceLabel)
        
        self.unitLabel.text = "万"
        self.unitLabel.textColor = ColorUtils.orangeTextColor
        self.unitLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.unitLabel)
        
        super.initViews()
    }
}
