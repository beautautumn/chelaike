import UIKit
import RxSwift
import Alamofire
import ZMKnife

class StoreSelectorViewController: BaseSingleSelectGroupListViewController, EnableNavigationSearchView {

    var keyword: String?
    let searchBar = SearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.textField.placeholder = "搜索车商名称关键字"
        self.enableNavigationSearchView(self.searchBar) { [unowned self] (keyword) in
            self.keyword = keyword
            self.refresh()
        }
        self.refresh()
    }

    func isNavigationIncludeOperates() -> Bool {
        return true
    }

    func refresh() {
        self.view.showRingLoading()
        let _ = CompanyApi.stores(["debtorName": self.keyword ?? ""]).subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    if let record = json as? [String: Any] {
                        if let records = record["data"] as? [[String: Any]] {
                            var data = [[String: Any]]()
                            records.forEach({ (record) in
                                let companyId = record["id"] as? Int
                                if let stores = record["stores"] as? [[String: Any]] {
                                    if stores.count > 0 {
                                        var groupData = [[String: Any]]()
                                        stores.forEach({ (item) in
                                            var result = [String: String]()
                                            if let name = item["name"] as? String {
                                                result["value"] = name
                                            }
                                            if let id = item["id"] as? Int {
                                                result["key"] = "\(id)"
                                            }
                                            if let address = item["address"] as? String {
                                                result["address"] = address
                                            }
                                            if let latitude = item["latitude"] as? Double {
                                                result["latitude"] = "\(latitude)"
                                            }
                                            if let longitude = item["longitude"] as? Double {
                                                result["longitude"] = "\(longitude)"
                                            }
                                            if let limitInventoryTimeLength = item["limitInventoryTimeLength"] as? Int {
                                                result["limitInventoryTimeLength"] = "\(limitInventoryTimeLength)"
                                            }
                                            if companyId != nil {
                                                result["companyId"] = "\(companyId!)"
                                            }
                                            groupData.append(result)
                                        })
                                        data.append(["letter": record["name"] ?? "", "data": groupData])
                                    }
                                }
                            })
                            self.reloadData(data, noneValue: nil, defaultSelectedKey: self.defaultSelectedKey)
                        }
                    }
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.noneValue == nil ? 22 : (section > 0 ? 22.0 : 0)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        var record: [String: String]? = nil
        if let itemRecord = self.data[sectionIndex]["data"] as? [[String: String]] {
            record = itemRecord[rowIndex]
        }
        if let callback = self.onSelected {
            callback(record)
        }
    }
}
