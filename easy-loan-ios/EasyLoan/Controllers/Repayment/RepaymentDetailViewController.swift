import UIKit
import RxSwift
import Alamofire

class RepaymentDetailViewController: BaseLoanDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "还款详情"
        carsView = LoanDetailBasicInfoView()
        (carsView as! LoanDetailBasicInfoView).onCarItemClickedListener = { [unowned self] (url) in
            let controller = BrowerViewController()
            controller.pageTitle = "微店预览"
            controller.pageUrl = url
            self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }

    override func isShowOperate() -> Bool {
        if UserModel.isAuthValid("还款单提交") && self.histories.count > 0 {
            return (self.histories[0]["contentState"] as? String) == "return_applied"
        }
        return false
    }
    
    override func operateTitle() -> String? {
        return "还款提交"
    }

    override func stateUpdateView() -> LoanStateUpdateView? {
        let stateUpdateView = LoanStateUpdateView()
        stateUpdateView.title = "还款提交"
        return stateUpdateView
    }

    override func query() -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return LoanApi.repaymentDetail(id)
        }
        return nil
    }

    override func updateState(_ note: String) -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return LoanApi.submitRepayment(id, note: note)
        }
        return nil
    }

    override func reloadCarsViewData(_ data: [String : AnyObject]) {
        (self.carsView as? LoanDetailBasicInfoView)?.reloadData(data, isRepayment: true)
    }
}
