import RxSwift
import Alamofire

struct ConfigApi {

    static func ossConfiguration() -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/ossToken")
    }
}
