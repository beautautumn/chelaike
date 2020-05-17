import UIKit
import RxSwift
import Alamofire

class RepaymentListViewController: LoanListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func query(_ currentPage: Int, perPage: Int) -> Observable<(HTTPURLResponse, Any)>? {
        var params = [String: Any]()
        params["page"] = currentPage
        params["size"] = perPage
        params["searchValue"] = self.keyword
        params["state"] = self.filterState
        params["debtorId"] = self.filterCompany
        params["brandName"] = self.filterBrand
        params["seriesName"] = self.filterSeries
        return LoanApi.repayments(params)
    }
    
    override func getStateKeys() -> [String] {
        return [
            "return_applied", "return_submitted",
            "return_confirmed", "return_canceled",
            "return_closed"
        ]
    }
    
    override func listViewEmptyText() -> String {
        return "没有找到符合该条件的还款申请"
    }
    
    override func onListCellViewClicked(_ record: AnyObject) {
        let controller =  RepaymentDetailViewController()
        controller.recordId = record["id"] as? Int
        let navigation = UINavigationController(rootViewController: controller)
        self.present(navigation, animated: true, completion: nil)
    }
    
    override func getListCellView(_ listView: UITableView, cellIdentifier: String, indexPath: IndexPath) -> UITableViewCell {
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
