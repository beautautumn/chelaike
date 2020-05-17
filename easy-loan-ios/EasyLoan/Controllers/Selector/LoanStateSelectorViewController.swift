import UIKit
import RxSwift
import Alamofire

class LoanStateSelectorViewController: BaseSingleSelectListViewController {
    
    fileprivate let enumerizeModel = EnumerizeModel.enumerize()
    
    var stateKeys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "状态"
        self.reloadData(self.getStates(self.stateKeys), noneValue: ["key": "-1", "value": "不限"], defaultSelectedKey: self.defaultSelectedKey)
    }
    
    fileprivate func getStates(_ keys: [String]) -> [[String: String]] {
        var result = [[String: String]]()
        keys.forEach({ (key) in
            result.append(self.getState(key))
        })
        return result
    }
    
    fileprivate func getState(_ key: String) -> [String: String] {
        var result = [String: String]()
        if let states = self.enumerizeModel?.loanBillStates {
            if let state = states.first(where: {$0.key == key}) {
                result = ["key": state.key, "value": state.value]
            }
        }
        return result
    }
    
}
