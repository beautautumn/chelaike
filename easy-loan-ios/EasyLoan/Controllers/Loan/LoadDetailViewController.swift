import UIKit
import RxSwift
import Alamofire
import ZMTimeLineView

class LoanDetailViewController: BaseLoanDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "借款详情"
        carsView = LoanDetailBasicInfoView()
        (carsView as! LoanDetailBasicInfoView).onCarItemClickedListener = { [unowned self] (url) in
            let controller = BrowerViewController()
            controller.pageTitle = "微店预览"
            controller.pageUrl = url
            self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }

    override func isShowOperate() -> Bool {
        if UserModel.isAuthValid("借款单提交") && self.histories.count > 0 {
            return (self.histories[0]["contentState"] as? String) == "borrow_applied"
        }
        return false
    }

    override func operateTitle() -> String? {
        return "借款提交"
    }

    override func updateState(_ note: String) -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return LoanApi.submitLoan(id, note: note)
        }
        return nil
    }

    override func stateUpdateView() -> LoanStateUpdateView? {
        let stateUpdateView = LoanStateUpdateView()
        stateUpdateView.title = "借款提交"
        stateUpdateView.isShowPrice = true
        stateUpdateView.price = "\((data["borrowedAmountWan"] as? Double) ?? 0)"
        stateUpdateView.priceTitle = "借款金额(万）"
        return stateUpdateView
    }

    override func query() -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return LoanApi.loadDetail(id)
        }
        return nil
    }

    override func reloadCarsViewData(_ data: [String : AnyObject]) {
        (self.carsView as? LoanDetailBasicInfoView)?.reloadData(data, isRepayment: false)
    }

    override func timeLineView(_ timeLineView: TimeLineView, contentView index: Int) -> UIView {
        let cell = super.timeLineView(timeLineView, contentView: index)
        cell.tag = index
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTimeLineViewCellClicked(_:))))
        return cell
    }

    override func timeLineViewCellTextColor(_ index: Int) -> UIColor {
        let history = self.histories[index]
        if index != 0 && self.isDuringReplaceState(history) {
            return ColorUtils.blueTextColor
        }
        return super.timeLineViewCellTextColor(index)
    }

    override func isTimeLineViewCellClickable(_ history: [String : AnyObject]) -> Bool {
        if self.isDuringRepaymentState(history) {
            return true
        }
        if self.isDuringReplaceState(history) {
            return true
        }
        return (history["contentState"] as? String) == "borrow_applied"
    }

    @objc func onTimeLineViewCellClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            let history = self.histories[tag]
            if self.isDuringRepaymentState(history) {
                let controller = RepaymentDetailViewController()
                controller.recordId = history["contentId"] as? Int
                self.navigationController?.pushViewController(controller, animated: true)
            } else if self.isDuringReplaceState(history) {
                let controller = ReplaceDetailViewController()
                controller.recordId = history["contentId"] as? Int
                self.navigationController?.pushViewController(controller, animated: true)
            } else if (history["contentState"] as? String) == "borrow_applied" {
                let controller = LoanOriginalDetailViewController()
                controller.recordId = self.recordId
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    fileprivate func isDuringRepaymentState(_ history: [String: AnyObject]) -> Bool {
        return (history["contentType"] as? String) == "repayment_bill"
    }

    fileprivate func isDuringReplaceState(_ history: [String: AnyObject]) -> Bool {
        return (history["contentType"] as? String) == "replace_cars_bill"
    }
}
