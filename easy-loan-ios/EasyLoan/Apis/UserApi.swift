import RxSwift
import Alamofire

struct UserApi {

    static func sendLoginToken(_ phoneNumber: String) -> Observable<(HTTPURLResponse, Any)> {
        let params = ["phone": phoneNumber]
        return HttpUtils.request(.post, "/session/verify_code", parameters: params)
    }

    static func login(_ phoneNumber: String, token: String) -> Observable<(HTTPURLResponse, Any)> {
        let params = ["phone": phoneNumber, "verifyCode": token]
        return HttpUtils.request(.post, "/session", parameters: params)
    }

    static func own() -> Observable<(HTTPURLResponse, Any)> {
        return HttpUtils.request(.get, "/app/own")
    }
    
    static func updateName(_ name: String) -> Observable<(HTTPURLResponse, Any)> {
        let params = ["name": name]
        return HttpUtils.request(.put, "/app/own/updateName", parameters: params)
    }

    static func sendUpdatePhoneToken(_ phoneNumber: String) -> Observable<(HTTPURLResponse, Any)> {
        let params = ["phone": phoneNumber]
        return HttpUtils.request(.post, "/app/own/verify_code", parameters: params)
    }

    static func updatePhone(_ phoneNumber: String, token: String) -> Observable<(HTTPURLResponse, Any)> {
        let params = ["phone": phoneNumber, "verifyCode": token]
        return HttpUtils.request(.post, "/app/own/save_phone", parameters: params)
    }
}
