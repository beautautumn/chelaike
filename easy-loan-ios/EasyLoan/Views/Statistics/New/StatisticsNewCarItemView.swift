import UIKit
import ZMKnife
import SpriteKit
import Kingfisher

class StatisticsNewCarItemView: BorderBottomView {

    fileprivate let timeLabel = UILabel()
    fileprivate let avatarImageView = UIImageView()
    fileprivate let nameLabel = UILabel()
    fileprivate let vinLabel = UILabel()

    override func updateConstraints() {
        super.updateConstraints()
        self.timeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-26)
            make.top.equalTo(self).offset(4)
            make.height.equalTo(10)
        }
        self.avatarImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(70)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(6)
            make.height.equalTo(52)
        }
        self.nameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(6)
            make.right.equalTo(self).offset(-26)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(6)
            make.height.greaterThanOrEqualTo(12)
        }
        self.vinLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(6)
            make.right.equalTo(self).offset(-26)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8)
            make.height.equalTo(10)
        }
    }

    override func initViews() {
        self.backgroundColor = UIColor.white
        self.timeLabel.textColor = ColorUtils.grayTextColor
        self.timeLabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(self.timeLabel)

        self.addSubview(self.avatarImageView)

        self.nameLabel.numberOfLines = 2
        self.nameLabel.textColor = ColorUtils.fontColor
        self.nameLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(self.nameLabel)

        self.vinLabel.textColor = ColorUtils.grayTextColor
        self.vinLabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(self.vinLabel)

        super.initViews()
    }

    func reloadData(_ data: [String: AnyObject]) {
        self.timeLabel.text = "盘库时间: \((data["inventoryCarTime"] as? String) ?? "-")"
        if (data["vinSource"] as? String) == "chelaike" {
            if let cover = CarUtils.parseCover(data["carImages"] as? [[String: AnyObject]]) {
                self.avatarImageView.kf.setImage(with: URL(string: ImageUtils.scalePath(cover, width: 70, height: 52)),
                                                 placeholder: UIImage(named: "default_car"))
            } else {
                self.avatarImageView.image = UIImage(named: "default_car")
            }
        } else {
            self.avatarImageView.image = UIImage(named: "car_not_exist")
        }
        let name = CarUtils.parseName(data["brandName"] as? String,
                                      series: data["seriesName"] as? String,
                                      style: data["styleName"] as? String)

        if name.isEmpty {
            self.nameLabel.text = "车辆名称无法识别"
        } else {
            self.nameLabel.text = name
        }
        self.vinLabel.text = "车架号:\((data["vin"] as? String) ?? "-")"
    }
}
