import UIKit
import SpriteKit

class CompanyDetailShopListView: UIView {

    fileprivate let contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    func reloadData(_ data: [[String: AnyObject]]) {
        for subView in self.contentView.subviews {
            subView.removeFromSuperview()
        }

        let headerView = CompanyDetailShopItemView()
        headerView.isHeader = true
        headerView.leftText = "分店名称"
        headerView.rightText = "盘库员"
        self.contentView.addSubview(headerView)
        for item in data {
            let view = CompanyDetailShopItemView()
            view.isHeader = false
            view.leftText = item["name"] as? String
            view.rightText = item["userName"] as? String
            self.contentView.addSubview(view)
        }

        self.snp.remakeConstraints { (make) in
            make.height.equalTo(41 * (data.count + 1) + 20)
        }
        self.contentView.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self)
            make.bottom.equalTo(self).offset(-20)
        }
        for (index, subView) in self.contentView.subviews.enumerated() {
            subView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(self.contentView)
                make.top.equalTo(self.contentView).offset(index * 41)
                make.height.equalTo(41)
            }
        }
    }

    fileprivate func initViews() {
        self.backgroundColor = UIColor.white
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = ColorUtils.separatorColor.cgColor
        self.contentView.layer.cornerRadius = 4
        self.contentView.clipsToBounds = true
        self.addSubview(self.contentView)
    }
}
