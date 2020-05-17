import UIKit
import RxSwift
import Alamofire

protocol BaseListViewControllerDelegate: class {
    
    func listViewEmptyText() -> String
    func onListCellViewClicked(_ record: AnyObject)
    func getListCellView(_ listView: UITableView, cellIdentifier: String, indexPath: IndexPath) -> UITableViewCell

    func query(_ currentPage: Int, perPage: Int) -> Observable<(HTTPURLResponse, Any)>?
}
