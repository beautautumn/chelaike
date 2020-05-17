import UIKit
import SnapKit
import RxSwift
import SwiftDate

class StatisticsNewTimeInfoView: UIView {

    var timeLimit: String? {
        didSet {
            self.timeLimitValueLabel.text = self.timeLimit ?? "-"
        }
    }

    fileprivate var timer: Disposable?
    fileprivate let startTitleLabel = UILabel()
    fileprivate let startValueLabel = UILabel()

    fileprivate let timeLimitTitleLabel = UILabel()
    fileprivate let timeLimitValueLabel = UILabel()

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
        self.startTitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(self).multipliedBy(0.5)
            make.top.equalTo(self).offset(24)
            make.height.equalTo(14)
        }
        self.startValueLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(self).multipliedBy(0.5)
            make.top.equalTo(self.startTitleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self).offset(-26)
        }
        self.timeLimitTitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.startTitleLabel.snp.right)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(24)
            make.height.equalTo(14)
        }
        self.timeLimitValueLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.startValueLabel.snp.right)
            make.right.equalTo(self).offset(-17)
            make.top.equalTo(self.timeLimitTitleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(self).offset(-26)
        }
    }

    func startTimer() {
        if let _ = self.timer {
            return
        }
        self.startValueLabel.text = DateInRegion().string(format: .custom("HH:mm"))
        self.timer = Observable<Int>.interval(1, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] (_) in
                self.startValueLabel.text = DateInRegion().string(format: .custom("HH:mm"))
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
        self.startTitleLabel.text = "盘库开始 \(DateInRegion().string(format: .custom("yyyy-MM-dd")))"
        self.startTitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.startTitleLabel.textColor = ColorUtils.fontColor
        self.addSubview(self.startTitleLabel)

        self.startValueLabel.text = DateInRegion().string(format: .custom("HH:mm"))
        self.startValueLabel.font = UIFont.systemFont(ofSize: 36)
        self.startValueLabel.textColor = ColorUtils.fontColor
        self.addSubview(self.startValueLabel)

        self.timeLimitTitleLabel.text = "盘库限时min"
        self.timeLimitTitleLabel.font = UIFont.systemFont(ofSize: 12)
        self.timeLimitTitleLabel.textColor = ColorUtils.fontColor
        self.timeLimitTitleLabel.textAlignment = .right
        self.addSubview(self.timeLimitTitleLabel)

        self.timeLimitValueLabel.text = "—"
        self.timeLimitValueLabel.font = UIFont.systemFont(ofSize: 36)
        self.timeLimitValueLabel.textColor = ColorUtils.fontColor
        self.timeLimitValueLabel.textAlignment = .right
        self.addSubview(self.timeLimitValueLabel)
    }
}
