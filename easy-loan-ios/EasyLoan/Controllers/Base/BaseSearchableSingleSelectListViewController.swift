import UIKit
import ZMKnife

class BaseSearchableSingleSelectListViewController: BaseSingleSelectListViewController, EnableNavigationSearchView {

    let searchBar = SearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableNavigationSearchView(self.searchBar) { [unowned self] (keyword) -> Void in
            self.queryData(keyword)
        }
    }

    func isNavigationIncludeOperates() -> Bool {
        return true
    }

    func searchBarPlaceholder() -> String? {
        return nil
    }

    func queryData(_ keyword: String?) {
    }
}
