import RxSwift
import Alamofire

struct InventoryApi {

    static func list(_ parameters: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/app/inventory/index", parameters: parameters)
    }

    static func detail(_ recordId: Int) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/app/inventory/\(recordId)")
    }

    static func create(_ parameters: [String: Any]) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.post, "/app/inventory/create", parameters: parameters)
    }
}
