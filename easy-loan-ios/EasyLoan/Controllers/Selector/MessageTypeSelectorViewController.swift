import UIKit
import RxSwift
import Alamofire

class MessageTypeSelectorViewController: BaseSingleSelectListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "类型"
        self.reloadData(
            [
                ["key": "借款申请", "value": "借款申请"],
                ["key": "还款申请", "value": "还款申请"],
                ["key": "换车申请", "value": "换车申请"],
                ["key": "借款状态变更", "value": "借款状态变更"],
                ["key": "还款状态变更", "value": "还款状态变更"],
                ["key": "换车状态变更", "value": "换车状态变更"]
            ],
            noneValue: ["key": "-1", "value": "不限"],
            defaultSelectedKey: self.defaultSelectedKey
        )
    }
}
