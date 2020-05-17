import RxSwift
import Alamofire

struct CompanyApi {

    static func list(_ params: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/app/debtor/index", parameters: params)
    }
    
    static func myCompanies(_ params: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/app/own/debtor", parameters: params)
    }

    static func detail(_ recordId: Int) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/app/debtor/\(recordId)")
    }
    
    static func stores(_ params: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/app/inventory/stores", parameters: params)
    }
}
