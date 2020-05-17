import RxSwift
import Alamofire

struct InventorApi {
    
    static func list(_ name: String) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/inventor", parameters: ["name": name])
    }
}
