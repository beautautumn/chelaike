import UIKit
import ZMKnife
import SpriteKit

class ReplaceDetailBasicInfoView: UIView {

    fileprivate var currentCars: [[String: AnyObject]] = []
    fileprivate var replaceCars: [[String: AnyObject]] = []

    var onCarItemClickedListener: ((String) -> Void)?

    func reloadData(_ data:[String:AnyObject]) {
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
        
        let currentCarsHeaderLabel = PaddingLabel()
        currentCarsHeaderLabel.text = "当前借款车辆"
        currentCarsHeaderLabel.textColor = UIColor.black
        currentCarsHeaderLabel.font = UIFont.systemFont(ofSize: 10)
        currentCarsHeaderLabel.backgroundColor = UIColor.white
        currentCarsHeaderLabel.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.addSubview(currentCarsHeaderLabel)
        currentCarsHeaderLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(10)
        }
        
        self.currentCars = ((data["loanValuationDto"] as? [String: AnyObject])?["loanBillCarForTransferDtos"] as? [[String: AnyObject]]) ?? []
        for (index, currentCar) in self.currentCars.enumerated() {
            let car = currentCar["car"] as! [String: AnyObject]
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
            carItemView.isOriginalCar = ((currentCar["state"] as? String) == "is_replaced")
            self.addSubview(carItemView)
            carItemView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(self).offset(37 + index * 68)
                make.height.equalTo(68)
            }
            carItemView.isUserInteractionEnabled = true
            carItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCurrentCarItemViewClicked(_:))))
        }

        let separatorView = UIView()
        separatorView.backgroundColor = ColorUtils.separatorColor
        self.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(37 + 68 * currentCars.count)
            make.height.equalTo(5)
        }
        
        let replaceCarsHeaderLabel = PaddingLabel()
        replaceCarsHeaderLabel.text = "替换车辆"
        replaceCarsHeaderLabel.textColor = UIColor.black
        replaceCarsHeaderLabel.font = UIFont.systemFont(ofSize: 10)
        replaceCarsHeaderLabel.backgroundColor = UIColor.white
        replaceCarsHeaderLabel.padding = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        self.addSubview(replaceCarsHeaderLabel)
        replaceCarsHeaderLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(separatorView.snp.bottom)
            make.height.equalTo(15)
        }

        let replaceCarsBaseTop = 57 + 68 * currentCars.count
        self.replaceCars = ((data["replaceValuationDto"] as? [String: AnyObject])?["loanBillCarForTransferDtos"] as? [[String: AnyObject]]) ?? []
        for (index, currentCar) in self.replaceCars.enumerated() {
            let car = currentCar["car"] as! [String: AnyObject]
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
            carItemView.isNewCar = ((currentCar["state"] as? String) == "will_replace")
            self.addSubview(carItemView)
            carItemView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(self).offset(replaceCarsBaseTop + index * 68)
                make.height.equalTo(68)
            }
            carItemView.isUserInteractionEnabled = true
            carItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onReplaceCarItemViewClicked(_:))))
        }
        self.snp.remakeConstraints { (make) in
            make.height.equalTo(57 + 68 * (currentCars.count + replaceCars.count))
        }
    }

    @objc func onCurrentCarItemViewClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            if let car = self.currentCars[tag]["car"] as? [String: AnyObject] {
                if let weshopUrl = car["weshopUrl"] as? String {
                    if let callback = self.onCarItemClickedListener {
                        callback(weshopUrl)
                    }
                }
            }
        }
    }

    @objc func onReplaceCarItemViewClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            if let car = self.replaceCars[tag]["car"] as? [String: AnyObject] {
                if let weshopUrl = car["weshopUrl"] as? String {
                    if let callback = self.onCarItemClickedListener {
                        callback(weshopUrl)
                    }
                }
            }
        }
    }
}
