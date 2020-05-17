import UIKit
import RxSwift
import Alamofire

class MessageViewController: BaseFilterableListViewController, BaseListViewControllerDelegate {
    
    var filterType = String()
    var filterCompany = String()
    var startDate = String()
    var endDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterBar.leftItemPlaceholder = "按类型"
        self.filterBar.centerItemPlaceholder = "按日期"
        self.filterBar.rightItemPlaceholder = "按车商"
        self.filterBar.itemClickedListener = { (position) -> Void in
            switch position {
            case 0:
                let controller = MessageTypeSelectorViewController()
                let navigation = UINavigationController(rootViewController: controller)
                controller.defaultSelectedKey = self.filterType
                self.present(navigation, animated: true, completion: nil)
                controller.onSelected = { (item) in
                    controller.onNavigationGoBackViewClicked()
                    if let selectedKey = item?["key"] {
                        self.filterType = selectedKey
                        self.filterBar.leftItemPlaceholder = item?["value"]
                    } else {
                        self.filterType = ""
                        self.filterBar.leftItemPlaceholder = "按类型"
                    }
                }
            case 1:
                let controller = DateRangeSelectorViewController()
                let navigation = UINavigationController(rootViewController: controller)
                controller.start = self.startDate
                controller.end = self.endDate
                controller.onSelected = { (date) in
                    controller.onNavigationGoBackViewClicked()
                    if let start = date?["start"] {
                        self.startDate = start
                    } else {
                        self.startDate = ""
                    }
                    if let end = date?["end"] {
                        self.endDate = end
                    } else {
                        self.endDate = ""
                    }
                    if self.startDate.isEmpty && self.endDate.isEmpty {
                        self.filterBar.centerItemPlaceholder = "按日期"
                    } else {
                        self.filterBar.centerItemPlaceholder = [self.startDate, self.endDate].filter(
                            { date in !date.isEmpty }
                            ).joined(separator: "~")
                    }
                }
                self.present(navigation, animated: true, completion: nil)
            default:
                let controller = CompanySelectorViewController()
                let navigation = UINavigationController(rootViewController: controller)
                controller.defaultSelectedKey = self.filterCompany
                self.present(navigation, animated: true, completion: nil)
                controller.onSelected = { (item) in
                    controller.onNavigationGoBackViewClicked()
                    if let selectedKey = item?["key"] {
                        self.filterCompany = selectedKey
                        self.filterBar.rightItemPlaceholder = item?["value"]
                    } else {
                        self.filterCompany = ""
                        self.filterBar.rightItemPlaceholder = "按车商"
                    }
                }
            }
        }
        self.listViewDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refresh(_:)),
                                               name: NSNotification.Name("MessageRefresh"),
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("MessageRefresh"),
                                                  object: nil)
    }
    
    override func registerListCellViewClass(_ listView: UITableView, cellIdentifier: String) {
        listView.register(MessageTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }
    
    func query(_ currentPage: Int, perPage: Int) -> Observable<(HTTPURLResponse, Any)>? {
        var params = [String: Any]()
        params["page"] = currentPage
        params["size"] = perPage
        params["operationRecordType"] = self.filterType
        params["debtorId"] = self.filterCompany
        params["startTime"] = self.startDate
        params["endTime"] = self.endDate
        return MessageApi.list(params)
    }
    
    func listViewEmptyText() -> String {
        return "没有找到符合该条件的消息"
    }
    
    func onListCellViewClicked(_ record: AnyObject) {
        switch "\(record["operationRecordType"] as! String)" {
        case "还款申请", "还款状态变更":
            let controller = RepaymentDetailViewController()
            controller.recordId = record["billId"] as? Int
            let navigation = UINavigationController(rootViewController: controller)
            self.present(navigation, animated: true, completion: nil)
        case "换车申请", "换车状态变更":
            let controller = ReplaceDetailViewController()
            controller.recordId = record["billId"] as? Int
            let navigation = UINavigationController(rootViewController: controller)
            self.present(navigation, animated: true, completion: nil)
        default:
            let controller = LoanDetailViewController()
            controller.recordId = record["billId"] as? Int
            let navigation = UINavigationController(rootViewController: controller)
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    func getListCellView(_ listView: UITableView, cellIdentifier: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = listView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.reloadData(self.data[indexPath.row])
        return cell
    }
}
