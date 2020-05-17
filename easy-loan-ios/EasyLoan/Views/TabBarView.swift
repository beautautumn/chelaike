import UIKit
import SnapKit

class TabBarView: UIView {

    var selectedIndex: Int = 0 {
        didSet {
            onSelectedChanged()
        }
    }

    var leftTitle: String? {
        didSet {
            leftLabal.text = leftTitle
        }
    }
    var rightTitle: String? {
        didSet {
            rightLabel.text = rightTitle
        }
    }

    var itemClickedListener: ((Int) -> Void)?

    fileprivate let leftLabal = UILabel()
    fileprivate let leftUnderLine = UIView()
    fileprivate let rightLabel = UILabel()
    fileprivate let rightUnderLine = UIView()

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
        self.leftLabal.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.right.equalTo(self.snp.centerX)
        }
        self.leftUnderLine.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.leftLabal)
            make.width.equalTo(20)
            make.bottom.equalTo(self).offset(-7)
            make.height.equalTo(3)
        }

        self.rightLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.centerX)
            make.right.top.bottom.equalTo(self)
        }
        self.rightUnderLine.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.rightLabel)
            make.width.equalTo(20)
            make.bottom.equalTo(self).offset(-7)
            make.height.equalTo(3)
        }
    }

    @objc func onItemViewClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            self.selectedIndex = tag
            if let callback = self.itemClickedListener {
                callback(tag)
            }
        }
    }

    fileprivate func initViews() {
        self.leftLabal.tag = 0
        self.leftLabal.font = UIFont.systemFont(ofSize: 17)
        self.leftLabal.textAlignment = NSTextAlignment.center
        self.leftLabal.isUserInteractionEnabled = true
        self.leftLabal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onItemViewClicked(_:))))
        self.addSubview(self.leftLabal)
        self.addSubview(self.leftUnderLine)

        self.rightLabel.tag = 1
        self.rightLabel.font = UIFont.systemFont(ofSize: 17)
        self.rightLabel.textAlignment = NSTextAlignment.center
        self.rightLabel.isUserInteractionEnabled = true
        self.rightLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onItemViewClicked(_:))))
        self.addSubview(self.rightLabel)
        self.addSubview(self.rightUnderLine)
        self.onSelectedChanged()
    }

    fileprivate func onSelectedChanged() {
        if self.selectedIndex == 0 {
            self.leftLabal.textColor = UIColor.white
            self.rightLabel.textColor = UIColor.black
            self.leftUnderLine.backgroundColor = UIColor.white
            self.rightUnderLine.backgroundColor = UIColor.clear
        } else {
            self.leftLabal.textColor = UIColor.black
            self.rightLabel.textColor = UIColor.white
            self.leftUnderLine.backgroundColor = UIColor.clear
            self.rightUnderLine.backgroundColor = UIColor.white
        }
    }
}
