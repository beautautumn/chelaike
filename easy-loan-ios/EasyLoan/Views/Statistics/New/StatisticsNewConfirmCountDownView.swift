import UIKit
import RxSwift
import SpriteKit
import SwiftDate

class StatisticsNewConfirmCountDownView: UIView {

    var remainSeconds: Int = 0

    var onTimoutListener: (() -> Void)?

    fileprivate var timer: Disposable?

    fileprivate let endTimeTitleLabel = UILabel()
    fileprivate let endTimeValueLabel = UILabel()
    fileprivate let remainTitleLabel = UILabel()
    fileprivate let remainValueLabel = StatisticsRemainTimeLabel()

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
        self.endTimeTitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(self).multipliedBy(0.5)
            make.top.equalTo(self).offset(24)
            make.height.equalTo(14)
        }
        self.endTimeValueLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(self).multipliedBy(0.5)
            make.top.equalTo(self.endTimeTitleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self)
        }

        self.remainTitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.endTimeTitleLabel.snp.right)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(24)
            make.height.equalTo(14)
        }
        self.remainValueLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.endTimeValueLabel.snp.right)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self.remainTitleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self)
        }
    }

    func startTimer(_ seconds: Int) {
        if let _ = self.timer {
            return
        }
        self.remainSeconds =  seconds
        self.setRemainTime()
        self.timer = Observable<Int>.interval(1, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] (_) in
                if self.remainSeconds <= 0 {
                    self.stopTimer()
                    if let callback = self.onTimoutListener {
                        callback()
                    }
                } else {
                    self.remainSeconds -= 1
                    self.setRemainTime()
                }
            })
    }

    func stopTimer() {
        if let timer = self.timer {
            timer.dispose()
            self.timer = nil
        }
    }

    fileprivate func initViews() {
        self.backgroundColor = UIColor.white

        self.endTimeTitleLabel.text = "盘库结束 \(DateInRegion().string(format: .custom("yyyy-MM-dd")))"
        self.endTimeTitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.endTimeTitleLabel.textColor = ColorUtils.fontColor
        self.addSubview(self.endTimeTitleLabel)

        self.endTimeValueLabel.text = "-"
        self.endTimeValueLabel.font = UIFont.systemFont(ofSize: 36)
        self.endTimeValueLabel.textColor = ColorUtils.fontColor
        self.addSubview(self.endTimeValueLabel)

        self.remainTitleLabel.text = "剩余时间"
        self.remainTitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.remainTitleLabel.textColor = ColorUtils.fontColor
        self.remainTitleLabel.textAlignment = .right
        self.addSubview(self.remainTitleLabel)

        self.remainValueLabel.minutes = 0
        self.remainValueLabel.seconds = 0
        self.remainValueLabel.textAlignment = .right
        self.addSubview(self.remainValueLabel)
    }

    fileprivate func setRemainTime() {
        self.remainValueLabel.minutes = self.remainSeconds / 60
        self.remainValueLabel.seconds = self.remainSeconds % 60
        self.endTimeValueLabel.text = DateInRegion().string(format: .custom("HH:mm"))
    }
}
