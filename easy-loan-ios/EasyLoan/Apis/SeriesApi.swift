import RxSwift
import Alamofire

struct SeriesApi {
    
    static func list(_ name: String) -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/brands/series", parameters: ["name": name])
    }
}
