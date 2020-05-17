import UIKit
import SnapKit

class CompanyDetailCreditListView: UIView {

    fileprivate let spaceView = UIView()
    fileprivate let headerLabel = UILabel()
    fileprivate let separatorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    func reloadData(_ data: [[String: AnyObject]]) {
        for (index, subView) in self.subviews.enumerated() {
            if index >= 3 {
                subView.removeFromSuperview()
            }
        }
        for item in data {
            let view = CompanyDetailCreditItemView()
            view.currentCreditAndLimitAmount = "\(item["currentCreditAmountWan"] as! String)/\(item["limitAmountWan"] as! String)万"
            view.inUseAmount = "\(item["inUseAmountWan"] as! String)万"
            view.unusedAmount = "\(item["unUseAmountWan"] as! String)万"
            if let funderCompany = item["funderCompany"] as? [String: AnyObject] {
                view.title = funderCompany["name"] as? String
                view.allowPartRepay = funderCompany["allowPartRepay"] as? Bool ?? false
            }
            self.addSubview(view)
        }
        self.snp.remakeConstraints { (make) in
            make.height.equalTo(54 + 215 * data.count)
        }
        self.spaceView.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(10)
        }
        self.headerLabel.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.spaceView.snp.bottom)
            make.height.equalTo(34)
        }
        self.separatorView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.headerLabel.snp.bottom)
            make.height.equalTo(1)
        }
        for (index, subView) in self.subviews.enumerated() {
            if index >= 3 {
                subView.snp.remakeConstraints { (make) in
                    make.left.equalTo(self).offset(10)
                    make.right.equalTo(self).offset(-10)
                    make.top.equalTo(self).offset(54 + 215 * (index - 3))
                    make.height.equalTo(205)
                }
            }
        }
    }

    fileprivate func initViews() {
        self.backgroundColor = UIColor.white
        self.spaceView.backgroundColor = ColorUtils.separatorColor
        self.addSubview(self.spaceView)

        self.headerLabel.text = "授信额度"
        self.headerLabel.font = UIFont.systemFont(ofSize: 14)
        self.headerLabel.textAlignment = .center
        self.addSubview(self.headerLabel)

        self.separatorView.backgroundColor = ColorUtils.separatorColor
        self.addSubview(self.separatorView)
    }
}
