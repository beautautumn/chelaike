import UIKit

class StatisticsRemainTimeLabel: UILabel {

    var minutes: Int? {
        didSet {
            setLabelText()
        }
    }

    var seconds: Int? {
        didSet {
            setLabelText()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    fileprivate func initViews() {
        self.font = UIFont.systemFont(ofSize: 36)
        self.textColor = ColorUtils.fontColor
    }

    fileprivate func setLabelText() {
        let minutes = self.parseValue(self.minutes)
        let seconds = self.parseValue(self.seconds)
        let text = "\(minutes)分\(seconds)秒"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.setAttributes(
            [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                NSAttributedStringKey.foregroundColor: ColorUtils.fontColor
            ], range: NSMakeRange(minutes.count, 1)
        )
        attributedText.setAttributes(
            [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                NSAttributedStringKey.foregroundColor: ColorUtils.fontColor
            ], range: NSMakeRange(text.count - 1, 1)
        )
        self.attributedText = attributedText
    }

    fileprivate func parseValue(_ value: Int?) -> String {
        if value == nil {
            return "00"
        }
        return value! > 9 ? "\(value!)" : "0\(value!)"
    }
}
