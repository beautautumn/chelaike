import UIKit
import RxSwift
import Alamofire

class ReplaceListViewController: LoanListViewController {
    
    fileprivate let enumerizeModel = EnumerizeModel.enumerize()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50 + 68 * self.getReplacedCars(indexPath.row).count)
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
        return LoanApi.replacements(params)
    }
    
    override func getStateKeys() -> [String] {
        return [
            "replace_review", "replace_apply",
            "replace_refused", "replace_submitted",
            "replace_confirmed"
        ]
    }
    
    override func listViewEmptyText() -> String {
        return "没有找到符合该条件的换车申请"
    }
    
    override func onListCellViewClicked(_ record: AnyObject) {
        let controller =  ReplaceDetailViewController()
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
            if let debtor = (record["debtor"] as? [String: Any]) {
                if let debtorName = debtor["name"] as? String {
                    cell.debtorName = debtorName
                }
            }
            if let createdAt = record["createdAt"] as? String {
                cell.createdAt = createdAt
            }
            if let state = record["state"] as? String {
                cell.state = state
                cell.stateText = self.getStateValue(state)
                cell.replaceCars = self.getReplacedCars(indexPath.row)
                if (record["borrowedAmountWan"] as? Double) != nil {
                    cell.borrowedAmountWan = "\(record["borrowedAmountWan"]!)"
                }
            }
            
        }
        
        return cell
    }
    
    fileprivate func getReplacedCars(_ index: Int) -> [[String: Any]] {
        var replaceCars = [[String: Any]]()
        if let record = self.data[index] as? [String: Any] {
            if let loanValuationDto = record["loanValuationDto"] as? [String: Any] {
                if let currentCars = loanValuationDto["loanBillCarForTransferDtos"] as? [[String: Any]] {
                    replaceCars += currentCars
                }
            }
            if let replaceValuationDto = record["replaceValuationDto"] as? [String: Any] {
                if let replacedCars = replaceValuationDto["loanBillCarForTransferDtos"] as? [[String: Any]] {
                    replaceCars += replacedCars
                }
            }
        }
        return replaceCars
    }
    
    fileprivate func getStateValue(_ key: String) -> String {
        var result = String()
        if let states = self.enumerizeModel?.loanBillStates {
            if let state = states.first(where: {$0.key == key}) {
                result = state.value
            }
        }
        return result
    }
    
}
