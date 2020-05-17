import UIKit

class SubmitButton: UIButton {

    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }

    var titleColor: UIColor? {
        didSet {
            setTitleColor(titleColor, for: .normal)
        }
    }


    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }

    fileprivate func initViews() {
        self.backgroundColor = ColorUtils.primaryColor
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
