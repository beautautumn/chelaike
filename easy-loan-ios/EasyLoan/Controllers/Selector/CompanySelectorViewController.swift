import UIKit
import RxSwift
import Alamofire

class CompanySelectorViewController: BaseSearchableSingleSelectListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.textField.placeholder = "搜索商家"
        self.loadData()
    }
    
    override func queryData(_ keyword: String?) {
        self.loadData(keyword)
    }
    
    func loadData(_ keyword: String? = nil) {
        self.view.showRingLoading()
        let _ = CompanyApi.list(["shopName": keyword ?? ""]).subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    if let record = json as? [String: Any] {
                        if let records = record["data"] as? [AnyObject] {
                            var data = [[String: String]]()
                            records.forEach({ (record) in
                                var item = [String: String]()
                                if let name = record["name"] as? String {
                                    item["value"] = name
                                }
                                if let id = record["id"] as? Int {
                                    item["key"] = "\(id)"
                                }
                                data.append(item)
                            })
                            self.reloadData(data, noneValue: ["key": "-1", "value": "不限"], defaultSelectedKey: self.defaultSelectedKey)
                        }
                        }
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }
}
