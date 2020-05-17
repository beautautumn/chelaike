import UIKit
import RxSwift
import Alamofire

class BrandSelectorViewController: BaseSingleSelectGroupListViewController {
    
    var defaultSelectedSeriesKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "品牌"
        self.view.showRingLoading()
        let _ = BrandApi.list().subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    if let data = json as? [String: Any] {
                        if let records = data["data"] as? [[String: Any]] {
                            var brands = [[String: String]]()
                            let letters = [
                                "A", "B", "C", "D", "E", "F", "G", "H",
                                "I", "J", "K", "L", "M", "N", "O", "P",
                                "Q", "R", "S", "T", "U", "V", "W", "X",
                                "Y", "Z", "#"
                            ]
                            records.forEach({ (record) in
                                var item = [String: String]()
                                if let name = record["name"] as? String {
                                    item["value"] = name
                                    item["key"] = name
                                }
                                if let firstLetter = record["first_letter"] as? String {
                                    item["firstLetter"] = firstLetter
                                } else {
                                    item["firstLetter"] = "#"
                                }
                                brands.append(item)
                            })
                            let result = letters.map { (letter) in
                                return [
                                    "letter": letter,
                                    "data": brands.filter { brand in brand["firstLetter"] == letter }
                                ]
                            }.filter { (group) in
                                if let data = group["data"] as? [[String: String]] {
                                    return  data.count > 0
                                }
                                return false
                            }
                            self.reloadData(result, noneValue: ["value": "不限", "key": "-1"], defaultSelectedKey: self.defaultSelectedKey)
                        }
                    }
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        var record: [String: String]? = nil
        if sectionIndex != 0 {
            if let itemRecord = self.data[sectionIndex]["data"] as? [[String: String]] {
                record = itemRecord[rowIndex]
                let controller = SeriesSelectorViewController()
                controller.brandName = record!["value"]!
                controller.defaultSelectedKey = self.defaultSelectedSeriesKey
                controller.onSelected = { (item) in
                    self.onNavigationGoBackViewClicked()
                    if let callback = self.onSelected {
                        if let selectedKey = item?["key"] {
                            callback(["brand": controller.brandName, "series": selectedKey])
                        } else {
                            callback(["brand": controller.brandName, "series": ""])
                        }
                    }
                }
                let navigation = UINavigationController(rootViewController: controller)
                self.present(navigation, animated: true, completion: nil)
            }
            return
        }
        if let callback = self.onSelected {
            callback(["brand": "", "series": ""])
        }
    }
    
}
