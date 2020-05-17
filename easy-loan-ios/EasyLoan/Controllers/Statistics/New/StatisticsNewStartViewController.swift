import UIKit
import ZMKnife
import RxSwift
import SpriteKit

class StatisticsNewStartViewController: BaseScrollViewController, SmartOcrViewControllerDelegate {

    var recordId: Int?
    var address: String?
    var coordinate: CLLocationCoordinate2D?

    fileprivate let timeInfoView = StatisticsNewCountDownView()
    fileprivate let scanCodeView = UIView()
    fileprivate let scanCodeButton = SubmitButton()
    fileprivate let carsHeaderLabel = PaddingLabel()

    fileprivate let locationManager = AMapLocationManager()

    fileprivate var data: [String: AnyObject] = [:]
    fileprivate var cars: [[String: AnyObject]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "盘库"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "结束盘库",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(submit))

        self.view.addSubview(self.timeInfoView)
        self.timeInfoView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(74)
        }
        self.timeInfoView.onTimoutListener = { [unowned self] () in
            self.view.showToast("本次盘库时间超时，系统自动保存,\n并且本店当天不再允许盘库！", messageColor: ColorUtils.timeoutTextColor, completion: { [unowned self] (_) in
                self.confirm()
            })
        }

        self.scanCodeView.backgroundColor = UIColor.white
        self.view.addSubview(self.scanCodeView)
        self.scanCodeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.timeInfoView.snp.bottom)
            make.height.equalTo(110)
        }
        self.scanCodeButton.title = "车架号扫码"
        self.scanCodeView.addSubview(self.scanCodeButton)
        self.scanCodeButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.scanCodeView).offset(10)
            make.right.equalTo(self.scanCodeView).offset(-10)
            make.bottom.equalTo(self.scanCodeView).offset(-30)
            make.height.equalTo(40)
        }
        self.scanCodeButton.setOnClickedListener { [unowned self] (_) in
            self.scan()
        }

        self.carsHeaderLabel.textAlignment = .center
        self.carsHeaderLabel.backgroundColor = UIColor.white
        self.carsHeaderLabel.font = UIFont.systemFont(ofSize: 12)
        self.carsHeaderLabel.textColor = ColorUtils.fontColor
        self.carsHeaderLabel.bottomBorderColor = ColorUtils.separatorColor
        self.carsHeaderLabel.padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.view.addSubview(self.carsHeaderLabel)
        self.carsHeaderLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.scanCodeView.snp.bottom).offset(10)
            make.height.equalTo(30)
        }

        self.view.showRingLoading()
        if self.address == nil || self.coordinate == nil {
            self.locationManager.requestLocation(withReGeocode: true) { [unowned self] (location, regeocode, _) in
                if let location = location {
                    self.coordinate = location.coordinate
                }
                if let regeocode = regeocode {
                    self.address = regeocode.formattedAddress
                }
                self.refresh()
            }
        } else {
            self.refresh()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onTimerStatusRecevie(_:)),
                                               name: NSNotification.Name("RestartStatisticsTimer"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onTimerStatusRecevie(_:)),
                                               name: NSNotification.Name("StopStatisticsTimer"),
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("RestartStatisticsTimer"),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("StopStatisticsTimer"),
                                                  object: nil)
    }

    override func isEnableNavigationGoBack() -> Bool {
        return false
    }

    override func initScrollViewConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(224)
            make.bottom.equalTo(self.view)
        }
    }

    @objc func onTimerStatusRecevie(_ notification: NSNotification) {
        if notification.name.rawValue == "RestartStatisticsTimer" {
            self.refresh()
        } else if notification.name.rawValue == "StopStatisticsTimer" {
            self.timeInfoView.stopTimer()
        }
    }

    fileprivate func refresh() {
        if let id = self.recordId {
            let _ = InventoryApi.detail(id)
                .subscribeOn(ConcurrentMainScheduler.instance)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] (response, json) in
                    if response.statusCode == 200 {
                        self.view.hideRingLoading()
                        if let data = (json as? [String: AnyObject])?["data"] as? [String: AnyObject] {
                            self.data = data
                            self.reloadData()
                        }
                    } else {
                        self.onHttpError(response, data: json)
                    }
                })
        }
    }

    fileprivate func reloadData() {
        self.cars = (self.data["cars"] as? [[String: AnyObject]]) ?? []
        self.timeInfoView.startTimer((self.data["usableInventoryTimeLengthSec"] as? Int) ?? 0)
        self.setCarsHeaderLabelText()
        for arrangedSubview in self.contentView.arrangedSubviews {
            self.contentView.removeArrangedSubview(arrangedSubview)
        }
        for (index, car) in self.cars.enumerated() {
            let carItemView = StatisticsNewCarItemView()
            carItemView.tag = index
            self.contentView.addArrangedSubview(carItemView)
            carItemView.snp.makeConstraints { (make) in
                make.height.equalTo(80)
            }
            carItemView.reloadData(car)
            carItemView.isUserInteractionEnabled = true
            carItemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCarItemViewClicked(_:))))
        }
    }

    fileprivate func setCarsHeaderLabelText() {
        let carCount = "\(self.cars.count)"
        let name = "\(self.data["debtorName"] as! String)-\(self.data["storeName"] as! String)盘库中，已录入"
        let text = "\(name)\(carCount)台"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.setAttributes(
            [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                NSAttributedStringKey.foregroundColor: ColorUtils.statisticsCarsCountTextColor
            ], range: NSMakeRange(name.count, carCount.count)
        )
        self.carsHeaderLabel.attributedText = attributedText
    }

    fileprivate func confirm() {
        let params: [String: Any] = [
            "debtorId": self.data["debtorId"] as! Int,
            "storeId": self.data["storeId"] as! Int,
            "inventoryAddress": self.address!,
            "storeLongitude": self.coordinate!.longitude,
            "storeLatitude": self.coordinate!.latitude,
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
                                                    userInfo: ["isTimeout": true])
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }

    @objc func onCarItemViewClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            if let weshopUrl = self.cars[tag]["weshopUrl"] as? String {
                let controller = BrowerViewController()
                controller.pageTitle = "微店预览"
                controller.pageUrl = weshopUrl
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            }
        }
    }

    @objc fileprivate func submit() {
        self.timeInfoView.stopTimer()
        let controller = StatisticsNewConfirmViewController()
        controller.data = self.data
        controller.address = self.address!
        controller.coordinate = self.coordinate!
        controller.remainSeconds = self.timeInfoView.remainSeconds
        controller.cancelListener = { [unowned self] (seconds) in
            self.timeInfoView.startTimer(seconds)
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc fileprivate func scan() {
        let controller = SmartOCRCameraViewController()
        controller.recogOrientation = .inVerticalScreen
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func onScanVin(_ vin: String?, imgagePath: String?) {
        if vin == nil || imgagePath == nil {
            self.view.showToast("扫码失败，请重试")
            return
        }
        self.view.showRingLoading()
        let _ = ImageClient.upload(imgagePath!)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (url) in
                self.view.hideRingLoading()
                if url == nil {
                    self.view.showToast("扫码失败，请重试")
                } else {
                    self.submitScanVin(vin!, imageUrl: url!)
                }
            })
    }

    fileprivate func submitScanVin(_ vin: String, imageUrl: String) {
        let params: [String: Any] = [
            "debtorId": self.data["debtorId"] as! Int,
            "storeId": self.data["storeId"] as! Int,
            "inventoryAddress": self.address!,
            "storeLongitude": self.coordinate!.longitude,
            "storeLatitude": self.coordinate!.latitude,
            "vin": vin,
            "carLongitude": self.coordinate!.longitude,
            "carLatitude": self.coordinate!.latitude,
            "phonePositioning": self.address!,
            "carImageUrl": [imageUrl],
            "buttonState": "doing"
        ]
        self.view.showRingLoading()
        let _ = InventoryApi.create(params)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    self.refresh()
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }
}
