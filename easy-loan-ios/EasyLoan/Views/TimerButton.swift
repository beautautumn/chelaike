import UIKit
import RxSwift

class TimerButton: UIButton {

    var title: String? {
        didSet {
            self.setTitle(self.title, for: .normal)
        }
    }

    var onClickedListener: (() -> Void)?

    fileprivate var timer: Disposable?
    fileprivate var buttonTitle: String?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    func stopTimer() {
        if let timer = self.timer {
            timer.dispose()
            self.timer = nil
            self.setTitle(self.buttonTitle, for: UIControlState.normal)
        }
    }

    func startTimer() {
        if let _ = self.timer {
            return
        }

        self.buttonTitle = self.titleLabel?.text
        self.setTitle("60秒后重试", for: UIControlState.normal)
        self.timer = Observable<Int>.interval(1, scheduler: MainScheduler.asyncInstance)
            .take(60)
            .subscribe(onNext: { [unowned self] (count) in
                let index = 59 - count
                if index > 0 {
                    self.setTitle("\(index)秒后重试", for: UIControlState.normal)
                } else {
                    self.stopTimer()
                }
            })
    }

    fileprivate func initViews() {
        self.backgroundColor = UIColor.white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.setTitleColor(ColorUtils.primaryColor, for: UIControlState.normal)
        self.setOnClickedListener { [unowned self] (_) in
            self.onClicked()
        }
    }

    fileprivate func onClicked() {
        if self.timer == nil {
            if let callback = self.onClickedListener {
                callback()
            }
        }
    }
}
