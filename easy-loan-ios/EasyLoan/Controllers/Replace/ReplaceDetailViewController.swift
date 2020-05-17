import UIKit
import RxSwift
import Alamofire

class ReplaceDetailViewController: BaseLoanDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "换车详情"
        carsView = ReplaceDetailBasicInfoView()
        (carsView as! ReplaceDetailBasicInfoView).onCarItemClickedListener = { [unowned self] (url) in
            let controller = BrowerViewController()
            controller.pageTitle = "微店预览"
            controller.pageUrl = url
            self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }

    override func isShowOperate() -> Bool {
        if UserModel.isAuthValid("换车单提交") && self.histories.count > 0 {
            return (self.histories[0]["contentState"] as? String) == "replace_apply"
        }
        return false
    }

    override func operateTitle() -> String? {
        return "换车提交"
    }

    override func stateUpdateView() -> LoanStateUpdateView? {
        let stateUpdateView = LoanStateUpdateView()
        stateUpdateView.title = "换车提交"
        return stateUpdateView
    }

    override func query() -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return LoanApi.replacementDetail(id)
        }
        return nil
    }

    override func updateState(_ note: String) -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return LoanApi.submitReplacement(id, note: note)
        }
        return nil
    }

    override func reloadCarsViewData(_ data: [String : AnyObject]) {
        (self.carsView as? ReplaceDetailBasicInfoView)?.reloadData(data)
    }
}
