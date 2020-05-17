import UIKit
import SnapKit
import SwiftIcons
import ZMKnife

class LoanTableViewCell: UITableViewCell {

    fileprivate let headerView = BorderBottomView()
    fileprivate let applyCodeLabel = UILabel()
    fileprivate let dateLabel = UILabel()
    fileprivate let companyLabel = UILabel()
    fileprivate let stateLabel = UILabel()
    fileprivate let bodyView = UIStackView()
    fileprivate let closedInfoView = UIView()
    fileprivate let borrowedAmountLabel = UILabel()
    fileprivate let closedDateLabel = UILabel()
    fileprivate let footerView = UILabel()
    
    var applyCode: String? {
        didSet {
            self.applyCodeLabel.text = String(format:"编号：%@", applyCode!)
        }
    }
    
    var createdAt: String? {
        didSet {
            self.dateLabel.text = createdAt
        }
    }
    
    var debtorName: String? {
        didSet {
            self.companyLabel.text = debtorName
        }
    }
    
    var closedAt: String? {
        didSet {
            self.closedDateLabel.text = String(format:"结算日期：%@", closedAt!)
        }
    }
    
    var initBorrowedAmountWan: String? {
        didSet {
            self.borrowedAmountLabel.text = String(format:"借款金额：%@万", initBorrowedAmountWan!)
        }
    }
    
    var stateText: String? {
        didSet {
            self.stateLabel.text = stateText
        }
    }
    
    var state: String? {
        didSet {
            if state == "closed" {
                self.closedInfoView.isHidden = false
                self.bodyView.isHidden = true
            } else {
                self.closedInfoView.isHidden = true
                self.bodyView.isHidden = false
            }
            switch state {
            case "replace_review", "return_applied", "replace_apply", "borrow_applied", "return_submitted", "borrow_submitted", "reviewed", "replace_submitted":
                self.stateLabel.textColor = ColorUtils.lightOrangeTextColor
            case "replace_refused", "borrow_refused":
                self.stateLabel.textColor = ColorUtils.redTextColor
            case "replace_confirmed", "return_confirmed", "borrow_confirmed":
                 self.stateLabel.textColor = ColorUtils.greenTextColor
            default:
                self.stateLabel.textColor = ColorUtils.grayTextColor
            }
        }
    }
    
    var borrowedAmountWan: String? {
        didSet {
            self.stateLabel.text = self.stateLabel.text! + "，" + borrowedAmountWan! + "万"
        }
    }
    
    var replaceCars: [[String: Any]]? {
        didSet {
            if let records = replaceCars {
                for carItemView in self.bodyView.subviews {
                    carItemView.removeFromSuperview()
                }
                records.forEach({ (record) in
                    if let car = record["car"] as? [String: Any] {
                        let state = record["state"] as? String
                        let carItem = self.drawCarView(
                            car,
                            isOriginalCar: state == "is_replaced",
                            isNewCar: state == "will_replace"
                        )
                        self.bodyView.addArrangedSubview(carItem)
                    }
                })
                self.bodyView.snp.remakeConstraints { (make) in
                    make.left.equalTo(self.contentView)
                    make.right.equalTo(self.contentView.snp.right)
                    make.top.equalTo(self.headerView.snp.bottom)
                    make.height.equalTo(68 * records.count)
                }
            }
        }
    }
    
    var cars: [[String: Any]]? {
        didSet {
            if let records = cars {
                let maxCarsCount = records.count > 3 ? 3 : records.count
                for carItemView in self.bodyView.subviews {
                    carItemView.removeFromSuperview()
                }
                for (index, car) in records.enumerated() {
                    if index <= maxCarsCount - 1 {
                        let carItem = self.drawCarView(car)
                        self.bodyView.addArrangedSubview(carItem)
                    }
                    
                }
                self.bodyView.snp.remakeConstraints { (make) in
                    make.left.equalTo(self.contentView)
                    make.right.equalTo(self.contentView.snp.right)
                    make.top.equalTo(self.headerView.snp.bottom)
                    make.height.equalTo(68 * maxCarsCount)
                }
                if records.count > maxCarsCount {
                    self.footerView.textAlignment = .center
                    self.footerView.textColor = UIColor.black
                    self.footerView.font = UIFont.systemFont(ofSize: 10)
                    self.footerView.setIcon(prefixText: "查看更多（共\(records.count)台）", icon: .ionicons(.chevronDown), postfixText: "", size: 10)
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initViews()
        self.initConstraints()
    }
    
    fileprivate func drawCarView(_ car: [String: Any] = [String: Any](),
                                 isOriginalCar: Bool = false,
                                 isNewCar: Bool = false) -> CarItemView {
        let carItem = CarItemView()
        carItem.isNewCar = isNewCar
        carItem.isShowLeftTag = true
        carItem.isOriginalCar = isOriginalCar
        if let vin = car["vin"] as? String {
            carItem.vin = vin
        }
        if (car["estimatePriceWan"] as? Double) != nil {
            carItem.estimatePrice = "\(car["estimatePriceWan"]!)"
        }
        if (car["showPriceWan"] as? Double) != nil {
            carItem.showPrice = "\(car["showPriceWan"]!)"
        }
        carItem.cover = CarUtils.parseCover(car["images"] as? [[String: AnyObject]])
        carItem.name = CarUtils.parseName(car["brandName"] as? String,
                                          series: car["seriesName"] as? String,
                                          style: car["styleName"] as? String)
        return carItem
    }
    
    fileprivate func initViews() {
        self.contentView.backgroundColor = ColorUtils.separatorColor
        self.contentView.addSubview(self.headerView)
        self.headerView.addSubview(self.applyCodeLabel)
        self.headerView.backgroundColor = UIColor.white
        self.applyCodeLabel.textColor = ColorUtils.grayTextColor
        self.applyCodeLabel.font = UIFont.systemFont(ofSize: 10)
        self.headerView.addSubview(self.dateLabel)
        self.dateLabel.textColor = ColorUtils.grayTextColor
        self.dateLabel.font = UIFont.systemFont(ofSize: 10)
        self.dateLabel.textAlignment = .right
        self.headerView.addSubview(self.companyLabel)
        self.companyLabel.textColor = ColorUtils.grayTextColor
        self.companyLabel.font = UIFont.systemFont(ofSize: 10)
        self.headerView.addSubview(self.stateLabel)
        self.stateLabel.textColor = ColorUtils.grayTextColor
        self.stateLabel.font = UIFont.systemFont(ofSize: 10)
        self.stateLabel.textAlignment = .right
        self.bodyView.axis = .vertical
        self.bodyView.alignment = .fill
        self.bodyView.distribution = .fillEqually
        self.contentView.addSubview(self.bodyView)
        self.contentView.addSubview(self.closedInfoView)
        self.borrowedAmountLabel.font = UIFont.systemFont(ofSize: 12)
        self.closedDateLabel.textAlignment = .right
        self.closedDateLabel.font = UIFont.systemFont(ofSize: 12)
        self.closedInfoView.addSubview(self.borrowedAmountLabel)
        self.closedInfoView.addSubview(self.closedDateLabel)
        self.closedInfoView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.footerView)
    }
    
    fileprivate func initConstraints() {
        self.headerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.contentView)
            make.height.equalTo(40)
        }
        self.applyCodeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerView).offset(10)
            make.right.equalTo(self.headerView.snp.centerX).offset(-10)
            make.top.equalTo(self.headerView).offset(7)
            make.height.equalTo(10)
        }
        self.dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.applyCodeLabel.snp.right)
            make.right.equalTo(self.headerView.snp.right).offset(-10)
            make.top.equalTo(self.headerView).offset(7)
            make.height.equalTo(10)
        }
        self.companyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerView).offset(10)
            make.right.equalTo(self.headerView.snp.centerX).offset(-10)
            make.top.equalTo(self.applyCodeLabel.snp.bottom).offset(7)
            make.height.equalTo(10)
        }
        self.stateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.companyLabel.snp.right).offset(10)
            make.right.equalTo(self.headerView.snp.right).offset(-10)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(7)
            make.height.equalTo(10)
        }
        self.closedInfoView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.headerView.snp.bottom)
            make.height.equalTo(40)
        }
        self.borrowedAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.closedInfoView).offset(10)
            make.right.equalTo(self.closedInfoView.snp.centerX)
            make.top.equalTo(self.closedInfoView)
            make.height.equalTo(40)
        }
        self.closedDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.borrowedAmountLabel.snp.right)
            make.right.equalTo(self.closedInfoView.snp.right).offset(-10)
            make.top.equalTo(self.closedInfoView)
            make.height.equalTo(40)
        }
        self.footerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.bodyView.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
