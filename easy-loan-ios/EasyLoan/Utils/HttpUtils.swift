import RxSwift
import Alamofire
import RxAlamofire

struct HttpUtils {

    static func request(_ method: Alamofire.HTTPMethod,
                        _ url: URLConvertible,
                        parameters: [String: Any]? = nil) -> Observable<(HTTPURLResponse, Any)> {
        var headers = [String:String]()
        if let currentUser = UserModel.currentUser() {
            headers["AutobotsToken"] = currentUser.token
        }
        headers["AutobotsPlatform"] = "iOS"
        headers["AutobotsDeviceNumber"] = ConfigUtils.deviceId()
        headers["AutobotsMobileAppVersion"] = ConfigUtils.version()
        var encoding: ParameterEncoding
        if method == .get {
            encoding = URLEncoding.queryString
        } else {
            encoding = JSONEncoding.default
        }
        return RxAlamofire.request(method, "\(ConfigUtils.apiRootUrl())/api/v1\(url)",
            parameters: parameters,
            encoding: encoding,
            headers: headers).flatMap { $0.rx.responseJSON() }
    }
}
