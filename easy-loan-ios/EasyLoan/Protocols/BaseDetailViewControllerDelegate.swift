import RxSwift
import Alamofire

protocol BaseDetailViewControllerDelegate: class {

    func reloadData(_ data: [String: AnyObject])
    func query() -> Observable<(HTTPURLResponse, Any)>?
}
