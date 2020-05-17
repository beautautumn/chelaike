import UIKit
import RxSwift
import SnapKit

class StatisticsNewShopChooseViewController: BaseScrollViewController {

    fileprivate var currentShop: [String: String]?

    fileprivate let shopSelectorView = DynamicArrowRightTitleAndValueTextView()
    fileprivate let userNameView = DynamicTitleAndValueTextView()
    fileprivate let addressView = StatisticsNewLocationView()
    fileprivate let mapView = MapView()
    fileprivate let timeInfoView = StatisticsNewTimeInfoView()

    fileprivate let submitButtonWrappView = UIView()
    fileprivate let submitButton = SubmitButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "盘库"
        self.view.backgroundColor = UIColor.white

        self.shopSelectorView.leftPadding = 16
        self.shopSelectorView.rightPadding = 16
        self.shopSelectorView.titleLabelWidth = 134
        self.shopSelectorView.title = "盘库门店"
        self.shopSelectorView.placeholder = "请选择车商门店"
        self.contentView.addArrangedSubview(self.shopSelectorView)
        self.shopSelectorView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
        self.shopSelectorView.onClickedListener = { [unowned self] () in
            let controller = StoreSelectorViewController()
            controller.defaultSelectedKey = self.currentShop?["key"]
            controller.onSelected = { [unowned self] (data) in
                controller.onNavigationGoBackViewClicked()
                self.onShopChanged(data)
            }
            self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }

        self.userNameView.leftPadding = 16
        self.userNameView.rightPadding = 16
        self.userNameView.titleLabelWidth = 134
        self.userNameView.title = "盘库员"
        self.userNameView.value = UserModel.currentUser()?.name
        self.contentView.addArrangedSubview(self.userNameView)

        self.addressView.leftPadding = 16
        self.addressView.rightPadding = 10
        self.addressView.titleLabelWidth = 134
        self.addressView.title = "定位"
        self.contentView.addArrangedSubview(self.addressView)
        self.addressView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
        self.addressView.onClickedListener = { [unowned self] () in
            self.mapView.startLocation()
        }

        self.mapView.backgroundColor = UIColor.white
        self.contentView.addArrangedSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.height.equalTo(180)
        }
        self.contentView.addArrangedSubview(self.timeInfoView)
        self.timeInfoView.snp.makeConstraints { (make) in
            make.height.equalTo(108)
        }
        self.timeInfoView.startTimer()

        self.contentView.addArrangedSubview(self.submitButtonWrappView)
        self.submitButtonWrappView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }

        self.submitButton.title = "开始盘库"
        self.submitButtonWrappView.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.submitButtonWrappView).offset(10)
            make.right.equalTo(self.submitButtonWrappView).offset(-10)
            make.top.bottom.equalTo(self.submitButtonWrappView)
        }
        self.submitButton.setOnClickedListener { [unowned self] (_) in
            self.submit()
        }

        self.mapView.startLocation()
        self.mapView.onLocationFinished = { [unowned self] () in
            self.addressView.value = self.mapView.address
        }
    }

    override func onNavigationGoBackViewClicked() {
        self.timeInfoView.stopTimer()
        super.onNavigationGoBackViewClicked()
    }

    fileprivate func submit() {
        if self.currentShop == nil {
            self.view.showToast("请选择车商门店")
            return
        }
        if self.mapView.isInLocation {
            self.view.showToast("正在定位中，请稍后")
            return
        }

        let alert = UIAlertController(title: "温馨提示", message: "请确认是否开始，开始后不能取消！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { [unowned self] (_) in
            self.startStatistics()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    fileprivate func startStatistics() {
        let params: [String: Any] = [
            "debtorId": Utils.parseStringToInt(self.currentShop?["companyId"]),
            "storeId": Utils.parseStringToInt(self.currentShop?["key"]),
            "inventoryAddress": self.mapView.address!,
            "storeLongitude": self.mapView.coordinate!.longitude,
            "storeLatitude": self.mapView.coordinate!.latitude,
            "buttonState": "start"
        ]
        self.view.showRingLoading()
        let _ = InventoryApi.create(params)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    self.timeInfoView.stopTimer()
                    if let data = (json as? [String: AnyObject])?["data"] as? [String: AnyObject] {
                        let controller = StatisticsNewStartViewController()
                        controller.recordId = data["id"] as? Int
                        controller.address = self.mapView.address
                        controller.coordinate = self.mapView.coordinate
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }

    fileprivate func onShopChanged(_ data: [String: String]?) {
        self.currentShop = data
        self.shopSelectorView.value = data?["value"]
        self.timeInfoView.timeLimit = data?["limitInventoryTimeLength"]
        self.mapView.shopCoordinate = CLLocationCoordinate2D(latitude: Double(self.currentShop?["latitude"] ?? "0")!,
                                                             longitude: Double(self.currentShop?["longitude"] ?? "0")!)
    }
}
