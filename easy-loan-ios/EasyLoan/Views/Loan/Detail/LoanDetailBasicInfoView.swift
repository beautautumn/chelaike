import UIKit
import SnapKit
import ZMKnife

class LoanDetailBasicInfoView: UIView {

    fileprivate var cars: [[String: AnyObject]] = []

    var onCarItemClickedListener: ((String) -> Void)?

    func reloadData(_ data:[String:AnyObject], isRepayment:Bool) {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        let headerView = TitleAndValueTextView()
        headerView.titleLabel.text = "编号：\(data["applyCode"] as! String)"
        headerView.titleLabel.font = UIFont.systemFont(ofSize: 10)
        headerView.titleLabel.textColor = UIColor.black
        headerView.valueLabel.text = data["createdAt"] as? String
        headerView.valueLabel.font = UIFont.systemFont(ofSize: 10)
        headerView.valueLabel.textColor = ColorUtils.grayTextColor
        headerView.bottomBorderColor = UIColor.white
        headerView.leftPadding = 10
        headerView.rightPadding = 10
        self.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(27)
        }
        self.cars = (data["cars"] as? [[String: AnyObject]]) ?? []
        for (index, car) in self.cars.enumerated() {
            let carItemView = CarItemView()
            carItemView.tag = index
            carItemView.cover = CarUtils.parseCover(car["images"] as? [[String: AnyObject]])
            carItemView.name = CarUtils.parseName(car["brandName"] as? String,
                                                  series: car["seriesName"] as? String,
                                                  style: car["styleName"] as? String)
            carItemView.vin = car["vin"] as? String
            if let showPrice = car["showPriceWan"] as? Double {
                carItemView.showPrice = "\(showPrice)"
            }
            if let estimatePrice = car["estimatePriceWan"] as? Double {
                carItemView.estimatePrice = "\(estimatePrice)"
            }
            self.addSubview(carItemView)
            carItemView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(self).offset(27 + index * 68)
                make.height.equalTo(68)
            }
            carItemView.isUserInteractionEnabled = true
            carItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCarItemViewClicked(_:))))
        }
        let priceView = LoanDetailPriceView()
        if isRepayment {
            priceView.title = "本单还款："
            priceView.price = "\((data["repaymentAmountWan"] as? Double) ?? 0)"
        } else {
            priceView.title = "本单借款："
            priceView.price = "\((data["borrowedAmountWan"] as? Double) ?? 0)"
        }
        self.addSubview(priceView)
        priceView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(40)
        }
        self.snp.remakeConstraints { (make) in
            make.height.equalTo(67 + 68 * cars.count)
        }
    }

    @objc func onCarItemViewClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            if let weshopUrl = self.cars[tag]["weshopUrl"] as? String {
                if let callback = self.onCarItemClickedListener {
                    callback(weshopUrl)
                }
            }
        }
    }
}
