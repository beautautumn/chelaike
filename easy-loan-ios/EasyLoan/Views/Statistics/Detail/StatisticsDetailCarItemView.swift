import UIKit
import ZMKnife
import SpriteKit
import Kingfisher

class StatisticsDetailCarItemView: BorderBottomView {

    fileprivate let timeLabel = UILabel()
    fileprivate let avatarImageView = UIImageView()
    fileprivate let nameLabel = UILabel()
    fileprivate let vinLabel = UILabel()

    fileprivate let impawnLabel = UILabel()
    fileprivate let stateLabel = UILabel()
    fileprivate let arrowRightImageView = UIImageView()

    override func updateConstraints() {
        super.updateConstraints()
        self.timeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-30)
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
            make.right.equalTo(self).offset(-30)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(6)
            make.height.greaterThanOrEqualTo(12)
        }
        self.vinLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(6)
            make.right.equalTo(self).offset(-110)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8)
            make.height.equalTo(10)
        }

        self.stateLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-30)
            make.width.greaterThanOrEqualTo(0)
            make.top.equalTo(self).offset(58)
            make.height.equalTo(10)
        }
        self.impawnLabel.snp.remakeConstraints { (make) in
            make.right.equalTo(self.stateLabel.snp.left)
            make.width.greaterThanOrEqualTo(0)
            make.top.equalTo(self).offset(58)
            make.height.equalTo(10)
        }
        self.arrowRightImageView.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(4)
            make.top.equalTo(self).offset(60)
            make.height.equalTo(8)
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

        self.impawnLabel.textColor = ColorUtils.blueTextColor
        self.impawnLabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(self.impawnLabel)

        self.stateLabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(self.stateLabel)

        self.arrowRightImageView.image = UIImage(named: "arrow_right")
        self.addSubview(self.arrowRightImageView)

        super.initViews()
    }

    func reloadData(_ data: [String: AnyObject]) {
        let stateColors = [
            "当前在库": UIColor(red:0.24, green:0.79, blue:0.50, alpha:1.00),
            "已出库": UIColor(red:0.85, green:0.57, blue:0.23, alpha:1.00),
            "未入库": UIColor(red:0.98, green:0.37, blue:0.32, alpha:1.00)
        ]
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

        if (data["loanState"] as? String) == "not_loan" {
            self.impawnLabel.text = nil
        } else {
            self.impawnLabel.text = "已质押/"
        }
        let stateText = (data["stateText"] as? String) ?? "未入库"
        self.stateLabel.text = stateText
        self.stateLabel.textColor = stateColors[stateText]
    }
}
