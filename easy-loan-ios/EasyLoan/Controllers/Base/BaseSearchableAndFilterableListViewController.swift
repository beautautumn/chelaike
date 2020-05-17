import UIKit
import ZMKnife

class BaseSearchableAndFilterableListViewController: BaseFilterableListViewController, EnableNavigationSearchView {

    var keyword: String?
    let searchBar = SearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableNavigationSearchView(self.searchBar) { [unowned self] (keyword) -> Void in
            self.keyword = keyword
            self.refresh()
        }
    }

    func isNavigationIncludeOperates() -> Bool {
        return false
    }
}
