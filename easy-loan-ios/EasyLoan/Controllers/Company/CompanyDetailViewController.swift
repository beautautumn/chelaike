import UIKit
import RxSwift
import SnapKit
import Alamofire

class CompanyDetailViewController: BaseDetailViewController, BaseDetailViewControllerDelegate {

    var recordId: Int?

    fileprivate let basicView = CompanyDetailBasicView()
    fileprivate let shopsView = CompanyDetailShopListView()
    fileprivate let creditsView = CompanyDetailCreditListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "车商详情"
        self.delegate = self
    }

    func reloadData(_ data: [String : AnyObject]) {
        if self.contentView.arrangedSubviews.count == 0 {
            self.contentView.addArrangedSubview(self.basicView)
            self.contentView.addArrangedSubview(self.shopsView)
            self.contentView.addArrangedSubview(self.creditsView)
        }
        self.basicView.reloadData(data)
        if let stores = data["storeDtos"] as? [[String: AnyObject]] {
            self.shopsView.reloadData(stores)
        }
        if let credits = data["loanAccreditedRecordDtosList"] as? [[String: AnyObject]] {
            self.creditsView.reloadData(credits)
        }
    }

    func query() -> Observable<(HTTPURLResponse, Any)>? {
        if let id = self.recordId {
            return CompanyApi.detail(id)
        }
        return nil
    }
}
