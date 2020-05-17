import RxSwift
import Alamofire

struct MessageApi {
    
    static func list(_ parameters: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/app/message", parameters: parameters)
    }
}
