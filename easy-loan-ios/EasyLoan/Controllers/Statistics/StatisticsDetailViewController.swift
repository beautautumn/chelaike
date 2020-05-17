import UIKit
import RxSwift
import Alamofire
import SpriteKit

class StatisticsDetailViewController: BaseDetailViewController, BaseDetailViewControllerDelegate {

    var recordId: Int?

    fileprivate let shopInfoView = DynamicTitleAndValueTextView()
    fileprivate let statisticsUserInfoView = DynamicTitleAndValueTextView()
    fileprivate let shopAddressInfoView = DynamicTitleAndValueTextView()
    fileprivate let statisticsAddressInfoView = DynamicTitleAndValueTextView()
    fileprivate let startTimeInfoView = DynamicTitleAndValueTextView()
    fileprivate let endTimeInfoView = DynamicTitleAndValueTextView()
    fileprivate let spaceView = UIView()
    fileprivate let carInfoView = StatisticsDetailCarListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "盘库详情"

        self.shopInfoView.leftPadding = 16
        self.shopInfoView.rightPadding = 30
        self.shopInfoView.titleLabelWidth = 134
        self.shopInfoView.title = "盘库门店"

        self.statisticsUserInfoView.leftPadding = 16
        self.statisticsUserInfoView.rightPadding = 30
        self.statisticsUserInfoView.titleLabelWidth = 134
        self.statisticsUserInfoView.title = "盘库员"


        self.shopAddressInfoView.leftPadding = 16
        self.shopAddressInfoView.rightPadding = 30
        self.shopAddressInfoView.titleLabelWidth = 134
        self.shopAddressInfoView.title = "门店地址"


        self.statisticsAddressInfoView.leftPadding = 16
        self.statisticsAddressInfoView.rightPadding = 30
        self.statisticsAddressInfoView.titleLabelWidth = 134
        self.statisticsAddressInfoView.title = "盘库地址"

        self.startTimeInfoView.leftPadding = 16
        self.startTimeInfoView.rightPadding = 30
        self.startTimeInfoView.titleLabelWidth = 134
        self.startTimeInfoView.title = "盘库开始"

        self.endTimeInfoView.leftPadding = 16
        self.endTimeInfoView.rightPadding = 30
        self.endTimeInfoView.titleLabelWidth = 134
        self.endTimeInfoView.title = "盘库结束"

        self.carInfoView.onCarItemClickedListener = { [unowned self] (url) in
            let controller = BrowerViewController()
            controller.pageTitle = "微店预览"
            controller.pageUrl = url
            self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }

        self.delegate = self
    }

    func reloadData(_ data: [String : AnyObject]) {
        for arrangedSubview in self.contentView.arrangedSubviews {
            self.contentView.removeArrangedSubview(arrangedSubview)
        }
        self.shopInfoView.value = data["storeAddress"] as? String
        self.statisticsUserInfoView.value = data["userName"] as? String
        self.shopAddressInfoView.value = data["storeAddress"] as? String
        self.statisticsAddressInfoView.value = data["inventoryAddress"] as? String
        self.statisticsAddressInfoView.isError = (data["positioningAbnormal"] as? Bool) ?? false
        self.startTimeInfoView.value = data["inventoryStartTime"] as? String
        self.endTimeInfoView.value = data["inventoryEndTime"] as? String

        self.contentView.addArrangedSubview(self.shopInfoView)
        self.contentView.addArrangedSubview(self.statisticsUserInfoView)
        self.contentView.addArrangedSubview(self.shopAddressInfoView)
        self.contentView.addArrangedSubview(self.statisticsAddressInfoView)
        self.contentView.addArrangedSubview(self.startTimeInfoView)
        self.contentView.addArrangedSubview(self.endTimeInfoView)
        self.contentView.addArrangedSubview(self.spaceView)
        self.spaceView.snp.makeConstraints { (make) in
            make.height.equalTo(10)
        }

        self.contentView.addArrangedSubview(self.carInfoView)
        self.carInfoView.reloadData((data["cars"] as? [[String: AnyObject]]) ?? [])
    }

    func query() -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return InventoryApi.detail(id)
        }
        return nil
    }
}
