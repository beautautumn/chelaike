import UIKit
import RxSwift
import SnapKit
import ZMKnife
import Alamofire
import ZMTimeLineView

class BaseLoanDetailViewController: BaseDetailViewController, TimeLineViewDataSource, BaseDetailViewControllerDelegate {

    var recordId: Int?
    var carsView: UIView?

    var data: [String: AnyObject] = [:]
    var histories: [[String: AnyObject]] = []

    fileprivate let funderView = TitleAndValueTextView()
    fileprivate let companyView = CompanyBriefInfoView()
    fileprivate let spaceView = UIView()
    fileprivate let timeLineView = TimeLineView()
    fileprivate let operateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.funderView.leftPadding = 10
        self.funderView.rightPadding = 10
        self.funderView.titleLabel.text = "放款机构"
        self.funderView.titleLabel.textColor = ColorUtils.fontColor
        self.funderView.valueLabel.textColor = ColorUtils.fontColor

        self.spaceView.backgroundColor = ColorUtils.separatorColor
        self.timeLineView.dataSource = self
        self.delegate = self

        self.operateLabel.text = self.operateTitle()
        self.operateLabel.textColor = UIColor.white
        self.operateLabel.textAlignment = .center
        self.operateLabel.font = UIFont.systemFont(ofSize: 14)
        self.operateLabel.backgroundColor = ColorUtils.primaryColor
        self.operateLabel.isUserInteractionEnabled = true
        self.operateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(onOperateLabelClicked)))
    }

    @objc func onOperateLabelClicked() {
        if let stateUpdateView = self.stateUpdateView() {
            stateUpdateView.onSubmitListener = { [unowned self] (note) in
                self.view.showRingLoading()
                if let response = self.updateState(note) {
                    let _ = response.subscribeOn(ConcurrentMainScheduler.instance)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { [unowned self] (response, json) in
                            if response.statusCode == 200 {
                                self.view.hideRingLoading()
                                stateUpdateView.removeFromSuperview()
                                self.refresh()
                            } else {
                                self.onHttpError(response, data: json)
                            }
                        })
                } else {
                    self.view.hideRingLoading()
                    stateUpdateView.removeFromSuperview()
                }
            }
            self.view.addSubview(stateUpdateView)
            stateUpdateView.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalTo(self.view)
            }
        }
    }
    
    func isShowOperate() -> Bool {
        return false
    }

    func operateTitle() -> String? {
        return nil
    }
    
    func stateUpdateView() -> LoanStateUpdateView? {
        return nil
    }

    func query() -> Observable<(HTTPURLResponse, Any)>? {
        return nil
    }

    func updateState(_ note: String) -> Observable<(HTTPURLResponse, Any)>? {
        return nil
    }

    func reloadData(_ data: [String : AnyObject]) {
        self.data = data
        if let histories = data["histories"] as? [[String: AnyObject]] {
            self.histories = histories
        } else if let histories = data["historyPcDtoList"] as? [[String: AnyObject]] {
            self.histories = histories
        } else if let histories = data["loanHistoryList"] as? [[String: AnyObject]] {
            self.histories = histories
        } else {
            self.histories = []
        }
        if self.isShowOperate() {
            if !self.view.subviews.contains(self.operateLabel) {
                self.view.addSubview(self.operateLabel)
            }
            self.scrollView.snp.remakeConstraints { (make) in
                make.left.right.top.equalTo(self.view)
                make.bottom.equalTo(self.view).offset(-40)
            }
            self.operateLabel.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalTo(self.view)
                make.height.equalTo(40)
            }
        } else {
            self.operateLabel.removeFromSuperview()
            self.scrollView.snp.remakeConstraints { (make) in
                make.left.right.top.bottom.equalTo(self.view)
            }
        }

        if self.contentView.arrangedSubviews.count == 0 {
            self.contentView.addArrangedSubview(self.funderView)
            if let carsView = self.carsView {
                self.contentView.addArrangedSubview(carsView)
            }
            self.contentView.addArrangedSubview(self.companyView)
            self.contentView.addArrangedSubview(self.spaceView)
            self.contentView.addArrangedSubview(self.timeLineView)
            self.funderView.snp.remakeConstraints { (make) in
                make.height.equalTo(40)
            }
            self.companyView.snp.remakeConstraints { (make) in
                make.height.equalTo(70)
            }
            self.spaceView.snp.remakeConstraints { (make) in
                make.height.equalTo(10)
            }
        }
        if let funderCompanyName = data["funderCompanyName"] as? String {
            self.funderView.valueLabel.text = funderCompanyName
        } else if let funderCompanyName = (data["funderCompany"] as? [String: AnyObject])?["name"] as? String {
            self.funderView.valueLabel.text = funderCompanyName
        }
        self.reloadCarsViewData(data)
        self.companyView.name = data["debtorName"] as? String
        self.companyView.userName = data["contactName"] as? String
        self.companyView.phoneNumber = data["contactPhone"] as? String
        self.companyView.address = data["address"] as? String
        self.companyView.onClickedListener = { [unowned self] () in
            let controller = CompanyDetailViewController()
            controller.recordId = data["debtorId"] as? Int
            self.navigationController?.pushViewController(controller, animated: true)
        }
        self.timeLineView.reloadData { [unowned self] (height) in
            self.timeLineView.snp.remakeConstraints({ (make) in
                make.height.equalTo(height)
            })
        }
    }

    func reloadCarsViewData(_ data: [String: AnyObject]) {
    }
    
    func numberOfTimeLineRecordCount(_ timeLineView: TimeLineView) -> Int {
        return self.histories.count
    }
    
    func timeLineView(_ timeLineView: TimeLineView, isHighlight index: Int) -> Bool {
        return index == 0
    }
    
    func timeLineView(_ timeLineView: TimeLineView, contentViewHeight contentView: UIView, index: Int) -> CGFloat {
        return (contentView as! TimeLineViewCell).height
    }

    func timeLineView(_ timeLineView: TimeLineView, contentView index: Int) -> UIView {
        let cell = TimeLineViewCell()
        let history = self.histories[index]
        cell.title = history["contentStateText"] as? String
        cell.content = history["note"] as? String
        cell.userName = history["operatorName"] as? String
        cell.date = history["createdAt"] as? String
        cell.textColor = self.timeLineViewCellTextColor(index)
        cell.clickable = self.isTimeLineViewCellClickable(history)
        return cell
    }

    func timeLineViewCellTextColor(_ index: Int) -> UIColor {
        if index == 0 {
            return TimeLineColors.highlightColor
        }
        return TimeLineColors.defaultColor
    }

    func isTimeLineViewCellClickable(_ history: [String: AnyObject]) -> Bool {
        return false
    }
}
