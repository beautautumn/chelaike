import UIKit
import SnapKit
import ZMKnife
import RxSwift
import PGDatePicker

class DateRangeSelectorViewController : BaseGoBackViewController, PGDatePickerDelegate {
    
    var onSelected: (([String: String]?) -> Void)?
    var start: String? {
        didSet {
            self.startDateLabel.text = start
        }
    }
    var end: String? {
        didSet {
            self.endDateLabel.text = end
        }
    }
    
    fileprivate let contentView = UIView()
    fileprivate let selectTitleLabel = UILabel()
    fileprivate let startDateLabel = PaddingLabel()
    fileprivate let endDateLabel = PaddingLabel()
    fileprivate let slashView = UIView()
    fileprivate let submitButton = SubmitButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "日期"
        self.initView()
        self.initViewConstraints()
    }
    
    func initView() {
        self.view.backgroundColor = ColorUtils.separatorColor
        
        self.selectTitleLabel.font = UIFont.systemFont(ofSize: 14)
        self.selectTitleLabel.text = "请选择日期"
        self.contentView.addSubview(self.selectTitleLabel)
        
        self.startDateLabel.layer.borderColor = ColorUtils.separatorColor.cgColor
        self.startDateLabel.layer.borderWidth = 1.0
        self.startDateLabel.layer.cornerRadius = 5.0
        self.startDateLabel.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.startDateLabel.font = UIFont.systemFont(ofSize: 14)
        self.startDateLabel.placeholder = "请选择日期"
        self.startDateLabel.isUserInteractionEnabled = true
        self.startDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onStartDateLabelClicked)))
        self.contentView.addSubview(self.startDateLabel)
        self.slashView.backgroundColor = UIColor.black
        self.contentView.addSubview(self.slashView)
        self.endDateLabel.layer.borderColor = ColorUtils.separatorColor.cgColor
        self.endDateLabel.layer.borderWidth = 1.0
        self.endDateLabel.layer.cornerRadius = 5.0
        self.endDateLabel.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.endDateLabel.font = UIFont.systemFont(ofSize: 14)
        self.endDateLabel.placeholder = "请选择日期"
        self.endDateLabel.isUserInteractionEnabled = true
        self.endDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onEndDateLabelClicked)))
        self.contentView.addSubview(self.endDateLabel)
        self.submitButton.title = "确认"
        self.submitButton.setOnClickedListener { [unowned self] (_) in
            self.submit()
        }
        self.contentView.addSubview(self.submitButton)
        
        self.contentView.backgroundColor = UIColor.white
        self.view.addSubview(self.contentView)
    }
    
    func initViewConstraints() {
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(236)
        }
        self.selectTitleLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(40)
        }
        self.startDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView.snp.centerX).offset(-20)
            make.top.equalTo(self.selectTitleLabel.snp.bottom)
            make.height.equalTo(32)
        }
        self.slashView.snp.makeConstraints { (make) in
            make.left.equalTo(self.startDateLabel.snp.right).offset(10)
            make.right.equalTo(self.endDateLabel.snp.left).offset(-10)
            make.top.equalTo(self.selectTitleLabel.snp.bottom).offset(15)
            make.height.equalTo(1)
        }
        self.endDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.centerX).offset(20)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.top.equalTo(self.selectTitleLabel.snp.bottom)
            make.height.equalTo(32)
        }
        self.submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.top.equalTo(self.startDateLabel.snp.bottom).offset(80)
            make.height.equalTo(40)
        }
    }
    
    fileprivate func initDatePickerWithTag(_ tag: Int) {
        let datePickerManager = PGDatePickManager()
        datePickerManager.isShadeBackgroud = true
        datePickerManager.confirmButtonTextColor = ColorUtils.primaryColor
        datePickerManager.confirmButtonText = "确定"
        datePickerManager.cancelButtonText = "清除"
        let datePicker = datePickerManager.datePicker!
        datePicker.datePickerType = .type2
        datePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if tag == 0 {
            datePicker.setDate(dateFormatter.date(from: self.start ?? ""))
        } else {
            datePicker.setDate(dateFormatter.date(from: self.end ?? ""))
        }
        datePicker.delegate = self
        datePicker.tag = tag
        datePicker.lineBackgroundColor = ColorUtils.primaryColor
        datePicker.textColorOfSelectedRow = ColorUtils.primaryColor
        self.present(datePickerManager, animated: false, completion: nil)
    }
    
    @objc func onStartDateLabelClicked() {
       self.initDatePickerWithTag(0)
    }
  
    @objc func onEndDateLabelClicked() {
        self.initDatePickerWithTag(1)
    }
    
    func datePicker(_ datePicker: PGDatePicker!, didSelectDate dateComponents: DateComponents!) {
        let date = "\(dateComponents.year!)-\(dateComponents.month!)-\(dateComponents.day!)"
        if datePicker.tag == 0 {
            self.start = date
        } else {
            self.end = date
        }
    }
    
    func cancelSelectDate(_ datePicker: PGDatePicker!) {
        if datePicker.tag == 0 {
            self.start = ""
        } else {
            self.end = ""
        }
    }
    
    fileprivate func submit() {
        if let callback = self.onSelected {
            callback(["start": self.start ?? "", "end": self.end ?? ""])
        }
    }
    
}
