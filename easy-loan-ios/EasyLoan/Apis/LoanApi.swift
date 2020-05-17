import RxSwift
import Alamofire

struct LoanApi {

    static func loans(_ parameters: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/loan_bill", parameters: parameters)
    }

    static func loadDetail(_ recordId: Int) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/loan_bill/\(recordId)")
    }

    static func submitLoan(_ recordId: Int, note: String) -> Observable<(HTTPURLResponse, Any)> {
        let params = ["id": recordId as Any, "state": "borrow_submitted", "note": note]
        return HttpUtils.request(.put, "/loan_bill/\(recordId)", parameters: params)
    }

    static func repayments(_ parameters: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/repayment_bill", parameters: parameters)
    }

    static func repaymentDetail(_ recordId: Int) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/repayment_bill/\(recordId)")
    }

    static func submitRepayment(_ recordId: Int, note: String) -> Observable<(HTTPURLResponse, Any)> {
        let params = [ "state": "return_submitted", "note": note]
        return HttpUtils.request(.put, "/repayment_bill/\(recordId)", parameters: params)
    }

    static func replacements(_ parameters: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/replaceCar", parameters: parameters)
    }

    static func replacementDetail(_ recordId: Int) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/replaceCar/carDetail/\(recordId)")
    }

    static func submitReplacement(_ recordId: Int, note: String) -> Observable<(HTTPURLResponse, Any)> {
        let params = ["id": recordId as Any, "state": "replace_submitted", "note": note]
        return HttpUtils.request(.post, "/replaceCar/\(recordId)", parameters: params)
    }
}
