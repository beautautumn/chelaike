import UIKit
import SnapKit

class ListFilterBar: UIView {
    
    var leftItemPlaceholder: String? {
        didSet {
            setItemViewText(0)
        }
    }
    var leftItemValue: String? {
        didSet {
            setItemViewText(0)
        }
    }

    var centerItemPlaceholder: String? {
        didSet {
            setItemViewText(1)
        }
    }
    var centerItemValue: String? {
        didSet {
            setItemViewText(1)
        }
    }

    var rightItemPlaceholder: String? {
        didSet {
            setItemViewText(2)
        }
    }
    var rightItemValue: String? {
        didSet {
            setItemViewText(2)
        }
    }

    var itemClickedListener: ((Int) -> Void)?

    fileprivate let leftItemView = UILabel()
    fileprivate let leftArrowImageView = UIImageView()
    fileprivate let centerItemView = UILabel()
    fileprivate let centerArrowImageView = UIImageView()
    fileprivate let rightItemView = UILabel()
    fileprivate let rightArrowImageView = UIImageView()
    
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
        self.leftItemView.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.3)
        }
        self.leftArrowImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.leftItemView.snp.right).offset(1)
            make.width.equalTo(8)
            make.centerY.equalTo(self)
            make.height.equalTo(5)
        }
        self.centerItemView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.leftArrowImageView.snp.right).offset(1)
            make.width.equalTo(self).multipliedBy(0.3)
            make.top.bottom.equalTo(self)
        }
        self.centerArrowImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.centerItemView.snp.right).offset(1)
            make.width.equalTo(8)
            make.centerY.equalTo(self)
            make.height.equalTo(5)
        }
        self.rightItemView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.centerArrowImageView.snp.right).offset(1)
            make.width.equalTo(self).multipliedBy(0.3)
            make.top.bottom.equalTo(self)
        }
        self.rightArrowImageView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.rightItemView.snp.right).offset(1)
            make.width.equalTo(8)
            make.centerY.equalTo(self)
            make.height.equalTo(5)
        }
    }
    
    @objc func onItemViewClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            if let callback = self.itemClickedListener {
                callback(tag)
            }
        }
    }

    fileprivate func initViews() {
        self.backgroundColor = ColorUtils.filterBarBgColor
        self.leftItemView.tag = 0
        self.leftItemView.textColor = ColorUtils.fontColor
        self.leftItemView.font = UIFont.systemFont(ofSize: 14)
        self.leftItemView.textAlignment = NSTextAlignment.center
        self.leftItemView.isUserInteractionEnabled = true
        self.leftItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onItemViewClicked(_:))))

        self.centerItemView.tag = 1
        self.centerItemView.textColor = ColorUtils.fontColor
        self.centerItemView.font = UIFont.systemFont(ofSize: 14)
        self.centerItemView.textAlignment = NSTextAlignment.center
        self.centerItemView.isUserInteractionEnabled = true
        self.centerItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onItemViewClicked(_:))))
        
        self.rightItemView.tag = 2
        self.rightItemView.textColor = ColorUtils.fontColor
        self.rightItemView.font = UIFont.systemFont(ofSize: 14)
        self.rightItemView.textAlignment = NSTextAlignment.center
        self.rightItemView.isUserInteractionEnabled = true
        self.rightItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onItemViewClicked(_:))))

        self.leftArrowImageView.image = UIImage(named: "arrow_down")
        self.centerArrowImageView.image = UIImage(named: "arrow_down")
        self.rightArrowImageView.image = UIImage(named: "arrow_down")

        self.addSubview(self.leftItemView)
        self.addSubview(self.leftArrowImageView)
        self.addSubview(self.centerItemView)
        self.addSubview(self.centerArrowImageView)
        self.addSubview(self.rightItemView)
        self.addSubview(self.rightArrowImageView)
    }

    fileprivate func setItemViewText(_ position: Int) {
        var label: UILabel?
        var value: String?
        var placeholder: String?
        switch position {
        case 0:
            label = self.leftItemView
            value = self.leftItemValue
            placeholder = self.leftItemPlaceholder
        case 1:
            label = self.centerItemView
            value = self.centerItemValue
            placeholder = self.centerItemPlaceholder
        case 2:
            label = self.rightItemView
            value = self.rightItemValue
            placeholder = self.rightItemPlaceholder
        default:
            label = nil
            value = nil
            placeholder = nil
        }

        if value?.isEmpty ?? true {
            label?.text = placeholder
        } else {
            label?.text = value
        }
    }
}
