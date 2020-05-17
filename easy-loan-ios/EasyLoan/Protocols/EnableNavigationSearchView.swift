import UIKit
import ZMKnife
import SnapKit

protocol EnableNavigationSearchView where Self:UIViewController {
    
    func enableNavigationSearchView(_ searchView: SearchView, onSearch: @escaping (String?) -> Void)
    func isNavigationIncludeOperates() -> Bool
}

extension EnableNavigationSearchView where Self:UIViewController {
    
    func enableNavigationSearchView(_ searchView: SearchView, onSearch: @escaping (String?) -> Void) {
        if let navigationWidth = self.navigationController?.navigationBar.frame.width {
            var searchViewWidth: CGFloat
            if self.isNavigationIncludeOperates() {
                searchViewWidth = navigationWidth * 0.8
            } else {
                searchViewWidth = navigationWidth * 0.9
            }
            searchView.tintColor = ColorUtils.primaryColor
            if #available(iOS 11, *) {
                searchView.snp.remakeConstraints { (make) in
                    make.width.equalTo(searchViewWidth)
                    make.height.equalTo(32)
                }
            } else {
                searchView.frame = CGRect(x: 0, y: 0, width: searchViewWidth, height: 32)
                searchView.updateConstraints()
            }
            self.navigationItem.titleView = searchView
            searchView.onSearch = onSearch
        }
    }
}
