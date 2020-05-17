import UIKit
import RxSwift
import SnapKit

class StatisticsNewConfirmViewController: BaseScrollViewController {

    var remainSeconds: Int?
    var data: [String: AnyObject] = [:]

    var address = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    var cancelListener: ((Int) -> Void)?

    fileprivate let headerView = UIView()
    fileprivate let headerImageView = UIImageView()
    fileprivate let headerLabel = UILabel()
    fileprivate let shopInfoView = DynamicTitleAndValueTextView()
    fileprivate let statisticsUserInfoView = DynamicTitleAndValueTextView()
    fileprivate let shopAddressInfoView = DynamicTitleAndValueTextView()
    fileprivate let statisticsAddressInfoView = DynamicTitleAndValueTextView()
    fileprivate let startTimeInfoView = DynamicTitleAndValueTextView()

    fileprivate let timeInfoView = StatisticsNewConfirmCountDownView()

    fileprivate let operatesView = UIView()
    fileprivate let submitButton = SubmitButton()
    fileprivate let cancelButton = SubmitButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "盘库"

        self.headerView.backgroundColor = ColorUtils.separatorColor
        self.contentView.addArrangedSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40)
        }
        self.headerImageView.image = UIImage(named: "error")
        self.headerView.addSubview(self.headerImageView)
        self.headerImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerView).offset(16)
            make.centerY.equalTo(self.headerView)
            make.size.equalTo(18)
        }
        self.headerLabel.text = "盘库结束后当天不允许再次盘库，请确认！"
        self.headerLabel.numberOfLines = 2
        self.headerLabel.textColor = ColorUtils.fontColor
        self.headerLabel.font = UIFont.systemFont(ofSize: 14)
        self.headerView.addSubview(self.headerLabel)
        self.headerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerImageView.snp.right).offset(5)
            make.right.equalTo(self.headerView).offset(-10)
            make.top.bottom.equalTo(self.headerView)
        }

        self.shopInfoView.leftPadding = 16
        self.shopInfoView.rightPadding = 30
        self.shopInfoView.titleLabelWidth = 134
        self.shopInfoView.title = "盘库门店"
        self.shopInfoView.value = self.data["storeAddress"] as? String
        self.contentView.addArrangedSubview(self.shopInfoView)

        self.statisticsUserInfoView.leftPadding = 16
        self.statisticsUserInfoView.rightPadding = 30
        self.statisticsUserInfoView.titleLabelWidth = 134
        self.statisticsUserInfoView.title = "盘库员"
        self.statisticsUserInfoView.value = self.data["userName"] as? String
        self.contentView.addArrangedSubview(self.statisticsUserInfoView)

        self.shopAddressInfoView.leftPadding = 16
        self.shopAddressInfoView.rightPadding = 30
        self.shopAddressInfoView.titleLabelWidth = 134
        self.shopAddressInfoView.title = "门店地址"
        self.shopAddressInfoView.value = self.data["storeAddress"] as? String
        self.contentView.addArrangedSubview(self.shopAddressInfoView)

        self.statisticsAddressInfoView.leftPadding = 16
        self.statisticsAddressInfoView.rightPadding = 30
        self.statisticsAddressInfoView.titleLabelWidth = 134
        self.statisticsAddressInfoView.title = "盘库地址"
        self.statisticsAddressInfoView.value = self.data["inventoryAddress"] as? String
        self.statisticsAddressInfoView.isError = (self.data["positioningAbnormal"] as? Bool) ?? false
        self.contentView.addArrangedSubview(self.statisticsAddressInfoView)

        self.startTimeInfoView.leftPadding = 16
        self.startTimeInfoView.rightPadding = 30
        self.startTimeInfoView.titleLabelWidth = 134
        self.startTimeInfoView.title = "盘库开始"
        self.startTimeInfoView.value = self.data["inventoryStartTime"] as? String
        self.startTimeInfoView.bottomBorderColor = UIColor.clear
        self.contentView.addArrangedSubview(self.startTimeInfoView)

        self.contentView.addArrangedSubview(self.timeInfoView)
        self.timeInfoView.snp.makeConstraints { (make) in
            make.height.equalTo(82)
        }
        self.timeInfoView.startTimer(self.remainSeconds ?? 0)
        self.timeInfoView.onTimoutListener = { [unowned self] () in
            self.view.showToast("本次盘库时间超时，系统自动保存,\n并且本店当天不再允许盘库！", messageColor: ColorUtils.timeoutTextColor, completion: { [unowned self] (_) in
                self.confirm(true)
            })
        }

        self.contentView.addArrangedSubview(self.operatesView)
        self.operatesView.snp.makeConstraints { (make) in
            make.height.equalTo(134)
        }

        self.submitButton.title = "保存"
        self.operatesView.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.operatesView).offset(10)
            make.right.equalTo(self.operatesView).offset(-10)
            make.top.equalTo(self.operatesView).offset(26)
            make.height.equalTo(40)
        }
        self.submitButton.setOnClickedListener { [unowned self] (_) in
            self.submit()
        }

        self.cancelButton.title = "取消"
        self.cancelButton.titleColor = ColorUtils.primaryColor
        self.cancelButton.backgroundColor = UIColor.white
        self.cancelButton.layer.borderWidth = 2
        self.cancelButton.layer.borderColor = ColorUtils.primaryColor.cgColor
        self.operatesView.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.operatesView).offset(10)
            make.right.equalTo(self.operatesView).offset(-10)
            make.top.equalTo(self.submitButton.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        self.cancelButton.setOnClickedListener { [unowned self] (_) in
            self.cancel()
        }
    }

    override func isEnableNavigationGoBack() -> Bool {
        return false
    }

    fileprivate func cancel() {
        self.timeInfoView.stopTimer()
        if let callback = self.cancelListener {
            callback(self.timeInfoView.remainSeconds)
        }
        self.navigationController?.popViewController(animated: true)
    }

    fileprivate func submit() {
        let alert = UIAlertController(title: "温馨提示", message: "盘库结束后当天不允许再次盘库，请确认！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [unowned self] (_) in
            self.confirm(false)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    fileprivate func confirm(_ isTimeOut: Bool) {
        let params: [String: Any] = [
            "debtorId": self.data["debtorId"] as! Int,
            "storeId": self.data["storeId"] as! Int,
            "inventoryAddress": self.address,
            "storeLongitude": self.coordinate.longitude,
            "storeLatitude": self.coordinate.latitude,
            "buttonState": "end"
        ]
        self.view.showRingLoading()
        let _ = InventoryApi.create(params)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    self.timeInfoView.stopTimer()
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("StatisticsStatusReceive"),
                                                    object: nil,
                                                    userInfo: ["isTimeout": isTimeOut])
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }
}
