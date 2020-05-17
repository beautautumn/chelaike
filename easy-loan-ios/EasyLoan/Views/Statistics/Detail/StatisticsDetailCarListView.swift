import UIKit
import ZMKnife
import SnapKit

class StatisticsDetailCarListView: UIView {

    fileprivate var cars: [[String: AnyObject]] = []

    var onCarItemClickedListener: ((String) -> Void)?

    func reloadData(_ data: [[String: AnyObject]]) {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        self.cars = data
        self.backgroundColor = UIColor.white
        let headerView = PaddingLabel()
        headerView.text = "共\(self.cars.count)辆"
        headerView.textColor = ColorUtils.grayTextColor
        headerView.font = UIFont.systemFont(ofSize: 10)
        headerView.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        headerView.backgroundColor = UIColor.white
        self.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(20)
        }

        let separatorView = UIView()
        separatorView.backgroundColor = ColorUtils.separatorColor
        self.addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(headerView.snp.bottom)
            make.height.equalTo(1)
        }

        for (index, car) in self.cars.enumerated() {
            let carItemView = StatisticsDetailCarItemView()
            carItemView.tag = index
            self.addSubview(carItemView)
            carItemView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(separatorView.snp.bottom).offset(index * 80)
                make.height.equalTo(80)
            }
            carItemView.reloadData(car)
            carItemView.isUserInteractionEnabled = true
            carItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCarItemViewClicked(_:))))
        }

        self.snp.remakeConstraints { (make) in
            make.height.equalTo(20 + cars.count * 80)
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
