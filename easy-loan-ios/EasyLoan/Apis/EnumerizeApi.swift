import RxSwift
import Alamofire

struct EnumerizeApi {

    static func enumerize() -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/enumerize")
    }
}
