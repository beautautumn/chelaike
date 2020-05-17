import RxSwift
import Alamofire

struct BrandApi {
    
    static func list() -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/brands")
    }
}
