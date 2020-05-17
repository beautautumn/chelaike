import UIKit
import SnapKit

class BaseFilterableListViewController: BaseListViewController {

    let filterBar = ListFilterBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.filterBar)
        self.filterBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(34)
        }
    }

    override func initListViewConstraints(_ listView: UITableView) {
        listView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view).offset(34)
        }
    }
}
