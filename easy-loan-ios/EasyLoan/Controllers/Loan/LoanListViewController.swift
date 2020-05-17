import UIKit
import RxSwift
import Alamofire

class LoanListViewController: BaseSearchableAndFilterableListViewController, BaseListViewControllerDelegate {

    var filterState = String()
    var filterCompany = String()
    var filterBrand = String()
    var filterSeries = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.textField.placeholder = "搜索品牌、车系、商家"
        self.filterBar.leftItemPlaceholder = "车商"
        self.filterBar.centerItemPlaceholder = "品牌"
        self.filterBar.rightItemPlaceholder = "状态"
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
                let controller = BrandSelectorViewController()
                controller.defaultSelectedKey = self.filterBrand
                controller.defaultSelectedSeriesKey = self.filterSeries
                controller.onSelected = { (item) in
                    controller.onNavigationGoBackViewClicked()
                    var brandText = ""
                    if let brandName = item?["brand"] {
                        self.filterBrand = brandName
                        brandText += brandName
                    }
                    if let seriesName = item?["series"] {
                        self.filterSeries = seriesName
                        brandText += seriesName
                    }
                    if brandText.isEmpty {
                        self.filterBar.centerItemPlaceholder = "品牌"
                    } else {
                        self.filterBar.centerItemPlaceholder = brandText
                    }
                }
                let navigation = UINavigationController(rootViewController: controller)
                self.present(navigation, animated: true, completion: nil)
            default:
                let controller = LoanStateSelectorViewController()
                let navigation = UINavigationController(rootViewController: controller)
                controller.defaultSelectedKey = self.filterState
                controller.stateKeys = self.getStateKeys()
                self.present(navigation, animated: true, completion: nil)
                controller.onSelected = { (item) in
                    controller.onNavigationGoBackViewClicked()
                    if let selectedKey = item?["key"] {
                        self.filterState = selectedKey
                        self.filterBar.rightItemPlaceholder = item?["value"]
                    } else {
                        self.filterState = ""
                        self.filterBar.rightItemPlaceholder = "状态"
                    }
                }
            }
        }
        self.listViewDelegate = self
    }
    
    override func registerListCellViewClass(_ listView: UITableView, cellIdentifier: String) {
        listView.register(LoanTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let record = self.data[indexPath.row] as? [String: Any] {
            if let state = record["state"] as? String {
                if state == "closed" {
                    return 90.0
                } else {
                    if let cars = record["cars"] as? [[String: Any]] {
                        let maxCarsCount = 3
                        return CGFloat(
                            (cars.count > maxCarsCount ? maxCarsCount : cars.count)  * 68 +
                                50 +
                                (cars.count > maxCarsCount ? 26 : 0)
                        )
                    }
                }
            }
        }
        return 40.0
    }
    
    func getStateKeys() -> [String] {
        return [
            "borrow_applied", "borrow_submitted",
            "reviewed", "borrow_confirmed",
            "borrow_refused",
            "canceled", "closed"
        ]
    }
    
    func query(_ currentPage: Int, perPage: Int) -> Observable<(HTTPURLResponse, Any)>? {
        var params = [String: Any]()
        params["page"] = currentPage
        params["size"] = perPage
        params["searchValue"] = self.keyword
        params["state"] = self.filterState
        params["debtorId"] = self.filterCompany
        params["brandName"] = self.filterBrand
        params["seriesName"] = self.filterSeries
        return LoanApi.loans(params)
    }
    
    func listViewEmptyText() -> String {
        return "没有找到符合该条件的借款申请"
    }
    
    func onListCellViewClicked(_ record: AnyObject) {
        let controller = LoanDetailViewController()
        controller.recordId = record["id"] as? Int
        let navigation = UINavigationController(rootViewController: controller)
        self.present(navigation, animated: true, completion: nil)
    }

    func getListCellView(_ listView: UITableView, cellIdentifier: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = listView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LoanTableViewCell
        if let record = self.data[indexPath.row] as? [String: Any] {
            if let applyCode = record["applyCode"] as? String {
                cell.applyCode = applyCode
            }
            if let debtorName = record["debtorName"] as? String {
                cell.debtorName = debtorName
            }
            if let createdAt = record["createdAt"] as? String {
                cell.createdAt = createdAt
            }
            if let stateText = record["stateText"] as? String {
                cell.stateText = stateText
            }
            if let state = record["state"] as? String {
                cell.state = state
                if state == "closed" {
                    if let closedAt = record["closedAt"] as? String {
                        cell.closedAt = closedAt
                    }
                    if (record["initBorrowedAmountWan"] as? Double) != nil {
                        cell.initBorrowedAmountWan = "\(record["initBorrowedAmountWan"]!)"
                    }
                } else {
                    if let cars = record["cars"] as? [[String: Any]] {
                        cell.cars = cars
                    }
                    if (record["borrowedAmountWan"] as? Double) != nil {
                        cell.borrowedAmountWan = "\(record["borrowedAmountWan"]!)"
                    }
                }
            }

        }
        
        return cell
    }

}
