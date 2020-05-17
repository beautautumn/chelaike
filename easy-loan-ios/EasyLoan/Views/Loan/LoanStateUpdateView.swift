import UIKit
import ZMKnife

class LoanStateUpdateView: OverlayView {

    var isShowPrice: Bool = false {
        didSet {
            if self.isShowPrice {
                self.contentView.addSubview(self.priceTextView)
            } else {
                self.priceTextView.removeFromSuperview()
            }
        }
    }

    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }

    var price: String? {
        didSet {
            self.priceTextView.valueLabel.text = self.price
        }
    }

    var priceTitle: String? {
        didSet {
            self.priceTextView.titleLabel.text = self.priceTitle
        }
    }

    var onSubmitListener: ((String) -> Void)?

    fileprivate let contentView = UIView()
    fileprivate let titleLabel = UILabel()
    fileprivate let closeImageView = UIImageView()
    fileprivate let separatorView = UIView()
    fileprivate let priceTextView = TitleAndValueTextView()
    fileprivate let noteTextView = PaddingTextView()

    fileprivate let submitLabel = UILabel()
    
    override func initViews() {
        super.initViews()
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContentViewClicked)))
        self.contentView.backgroundColor = UIColor.white
        self.addSubview(self.contentView)
        
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(self.titleLabel)
        
        self.closeImageView.image = UIImage(named: "close")
        self.closeImageView.isUserInteractionEnabled = true
        self.closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClicked)))
        self.contentView.addSubview(self.closeImageView)
        
        self.separatorView.backgroundColor = ColorUtils.separatorColor
        self.contentView.addSubview(self.separatorView)

        self.priceTextView.leftPadding = 6
        self.priceTextView.rightPadding = 6
        self.priceTextView.titleLabel.textColor = ColorUtils.fontColor
        self.priceTextView.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.priceTextView.valueLabel.textColor = ColorUtils.grayTextColor
        self.priceTextView.valueLabel.font = UIFont.systemFont(ofSize: 14)
        
        self.noteTextView.placeholder = "添加备注"
        self.noteTextView.textColor = ColorUtils.fontColor
        self.noteTextView.font = UIFont.systemFont(ofSize: 14)
        self.noteTextView.padding = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.contentView.addSubview(self.noteTextView)

        self.submitLabel.text = "确定"
        self.submitLabel.textColor = UIColor.white
        self.submitLabel.textAlignment = .center
        self.submitLabel.font = UIFont.systemFont(ofSize: 14)
        self.submitLabel.backgroundColor = ColorUtils.primaryColor
        self.submitLabel.isUserInteractionEnabled = true
        self.submitLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSubmit)))
        self.addSubview(self.submitLabel)
    }

    override func updateConstraints() {
        super.updateConstraints()
        self.contentView.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-40)
            make.height.equalTo(self.isShowPrice ? 164 : 124)
        }
        self.titleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.title?.size(self.titleLabel.font).width ?? 0)
            make.top.equalTo(self.contentView)
            make.height.equalTo(40)
        }
        self.closeImageView.snp.remakeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-16)
            make.top.equalTo(self.contentView).offset(15)
            make.size.equalTo(10)
        }
        self.separatorView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.height.equalTo(1)
        }
        if self.isShowPrice {
            self.priceTextView.snp.remakeConstraints { (make) in
                make.left.equalTo(self.contentView).offset(10)
                make.right.equalTo(self.contentView).offset(-10)
                make.top.equalTo(self.separatorView.snp.bottom)
                make.height.equalTo(44)
            }
        }
        self.noteTextView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(83)
        }
        
        self.submitLabel.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(40)
        }
    }

    @objc func onContentViewClicked() {
    }

    @objc func onSubmit() {
        if let callback = self.onSubmitListener {
            callback(self.noteTextView.text)
        }
    }
}
