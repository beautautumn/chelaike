import UIKit
import RxSwift
import Alamofire

class StatisticsListViewController: BaseSearchableAndFilterableListViewController, BaseListViewControllerDelegate {

    var startDate = String()
    var endDate = String()
    var filterCompany = String()
    var filterInventor = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.textField.placeholder = "搜索车商名称、盘库员"
        self.filterBar.leftItemPlaceholder = "车商"
        self.filterBar.centerItemPlaceholder = "盘库员"
        self.filterBar.rightItemPlaceholder = "盘库日期"
        self.filterBar.itemClickedListener = { (position) -> Void in
            switch position {
            case 0:
                let controller = CompanySelectorViewController()
                let navigation = UINavigationController(rootViewController: controller)
                controller.defaultSelectedKey = self.filterCompany
                self.present(navigation, animated: true, completion: nil)
                controller.onSelected = { (item) in
                    controller.onNavigationGoBackViewClicked()
                    if let selectedKey = item?["key"] {
                        self.filterCompany = selectedKey
                        self.filterBar.leftItemPlaceholder = item?["value"]
                    } else {
                        self.filterCompany = ""
                        self.filterBar.leftItemPlaceholder = "车商"
                    }
                }
            case 1:
                let controller = InventorSelectorViewController()
                let navigation = UINavigationController(rootViewController: controller)
                controller.defaultSelectedKey = self.filterInventor
                self.present(navigation, animated: true, completion: nil)
                controller.onSelected = { (item) in
                    controller.onNavigationGoBackViewClicked()
                    if let selectedKey = item?["key"] {
                        self.filterInventor = selectedKey
                        self.filterBar.centerItemPlaceholder = item?["value"]
                    } else {
                        self.filterInventor = ""
                        self.filterBar.centerItemPlaceholder = "盘库员"
                    }
                }
            default:
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
                        self.filterBar.rightItemPlaceholder = "盘库日期"
                    } else {
                        self.filterBar.rightItemPlaceholder = [self.startDate, self.endDate].filter(
                            { date in !date.isEmpty }
                        ).joined(separator: "~")
                    }
                }
                self.present(navigation, animated: true, completion: nil)
            }
        }
        self.listViewDelegate = self

        if UserModel.isAuthValid("到店盘库") {
            let addView = UIButton(type: UIButtonType.custom)
            if #available(iOS 11, *) {
                addView.snp.makeConstraints { (make) in
                    make.width.equalTo(21)
                    make.height.equalTo(21)
                }
            } else {
                addView.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
            }
            addView.setImage(UIImage.init(named: "add"), for: UIControlState.normal)
            addView.addTarget(self, action: #selector(add), for: UIControlEvents.touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addView)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onStatisticsStatusRecevie(_:)),
                                               name: NSNotification.Name("StatisticsStatusReceive"),
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("StatisticsStatusReceive"),
                                                  object: nil)
    }

    override func isNavigationIncludeOperates() -> Bool {
        return true
    }

    override func registerListCellViewClass(_ listView: UITableView, cellIdentifier: String) {
        listView.register(StatisticsTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81.0
    }

    func query(_ currentPage: Int, perPage: Int) -> Observable<(HTTPURLResponse, Any)>? {
        var params = [String: Any]()
        params["page"] = currentPage
        params["size"] = perPage
        params["searchValue"] = self.keyword
        params["debtorId"] = self.filterCompany
        params["inventorId"] = self.filterInventor
        params["fromTime"] = self.startDate
        params["toTime"] = self.endDate
        return InventoryApi.list(params)
    }
    func listViewEmptyText() -> String {
        return "没有找到符合该条件的盘库信息"
    }

    func onListCellViewClicked(_ record: AnyObject) {
        if let isDoing = record["isDoing"] as? Bool {
            if isDoing {
                if UserModel.isAuthValid("到店盘库") {
                    let controller = StatisticsNewStartViewController()
                    controller.recordId = record["id"] as? Int
                    self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
                } else {
                    self.view.showToast("无到店盘库权限")
                }
            } else {
                let controller = StatisticsDetailViewController()
                controller.recordId = record["id"] as? Int
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            }
        }
    }

    func getListCellView(_ listView: UITableView, cellIdentifier: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = listView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StatisticsTableViewCell
        cell.reloadData(self.data[indexPath.row] as! [String : AnyObject])
        return cell
    }

    @objc func add() {
        let controller = StatisticsNewShopChooseViewController()
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }

    @objc func onStatisticsStatusRecevie(_ notification: NSNotification) {
        if let userInfo = notification.userInfo as? [String: AnyObject] {
            if let isTimeout = userInfo["isTimeout"] as? Bool {
                if isTimeout {
                    self.view.showToast("本次盘库已保存", messageColor: ColorUtils.timeoutTextColor, completion: nil)
                } else {
                    self.view.showToast("本次盘库已保存")
                }
                self.refresh(false)
            }
        }
    }
}
