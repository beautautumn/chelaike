import UIKit
import RxSwift
import Alamofire

class CompanyListViewController: BaseSearchableListViewController, BaseListViewControllerDelegate, EnableNavigationGoBack {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableNavigationGoBack()
        self.searchBar.textField.placeholder = "搜索商家名称/归属业务员"
        self.listViewDelegate = self
    }

    override func isNavigationIncludeOperates() -> Bool {
        return true
    }

    override func registerListCellViewClass(_ listView: UITableView, cellIdentifier: String) {
        listView.register(CompanyTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func listViewEmptyText() -> String {
        return "没有找到符合该条件的商家信息"
    }

    func onListCellViewClicked(_ record: AnyObject) {
        let controller = CompanyDetailViewController()
        controller.recordId = record["id"] as? Int
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func getListCellView(_ listView: UITableView, cellIdentifier: String, indexPath: IndexPath) -> UITableViewCell {
        let cell = listView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CompanyTableViewCell
        cell.reloadData(self.data[indexPath.row] as! [String: AnyObject])
        return cell
    }

    func query(_ currentPage: Int, perPage: Int) -> Observable<(HTTPURLResponse, Any)>? {
        return CompanyApi.myCompanies(["page": currentPage, "size": perPage, "searchValue": self.keyword ?? ""])
    }

    func onNavigationGoBackViewClicked() {
        if let rootViewController = self.navigationController?.viewControllers.first {
            if rootViewController.isEqual(self) {
                self.navigationController?.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
