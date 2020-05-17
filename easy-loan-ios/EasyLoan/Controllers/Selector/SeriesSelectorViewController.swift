import UIKit
import RxSwift
import Alamofire

class SeriesSelectorViewController: BaseSingleSelectGroupListViewController {
    
    var brandName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "车系"
        self.view.showRingLoading()
        let _ = SeriesApi.list(self.brandName).subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    if let record = json as? [String: Any] {
                        if let records = record["data"] as? [[String: Any]] {
                            var data = [[String: Any]]()
                            records.forEach({ (record) in
                                if let series = record["series"] as? [[String: Any]] {
                                    var groupData = [[String: Any]]()
                                    series.forEach({ (item) in
                                        var result = [String: String]()
                                        if let name = item["name"] as? String {
                                            result["value"] = name
                                            result["key"] = name
                                        }
                                        groupData.append(result)
                                    })
                                    data.append(["letter": record["manufacturer_name"] ?? "", "data": groupData])
                                }
                            })
                            self.reloadData(data, noneValue: ["value": "不限", "key": "-1"], defaultSelectedKey: self.defaultSelectedKey)
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
        if sectionIndex != 0 {
            if let itemRecord = self.data[sectionIndex]["data"] as? [[String: String]] {
                record = itemRecord[rowIndex]
            }
        }
        if let callback = self.onSelected {
            callback(record)
        }
    }
}
