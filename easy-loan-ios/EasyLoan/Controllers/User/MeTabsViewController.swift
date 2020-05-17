import UIKit
import Pageboy

class MeTabsViewController: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate {

    fileprivate let tabBarView = TabBarView()
    fileprivate let viewControllers = [MeViewController(), MessageViewController()]
    var selectedTabIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let navigationBarWidth = self.navigationController?.navigationBar.frame.width ?? 0
        self.delegate = self
        self.dataSource = self
        self.tabBarView.leftTitle = "我的"
        self.tabBarView.rightTitle = "消息"
        if #available(iOS 11, *) {
            self.tabBarView.snp.makeConstraints { (make) in
                make.width.equalTo(navigationBarWidth)
                make.height.equalTo(navigationBarHeight)
            }
        } else {
            self.tabBarView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: navigationBarWidth,
                                           height: navigationBarHeight)
            self.tabBarView.updateConstraints()
        }
        self.tabBarView.itemClickedListener = { [unowned self] (index) -> Void in
            self.selectedTabIndex = index
            self.scrollToPage(Page.at(index: index), animated: true)
        }
        self.navigationItem.titleView = self.tabBarView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollToPage(Page.at(index: self.selectedTabIndex), animated: false)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return self.viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return self.viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.first
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        self.tabBarView.selectedIndex = index
    }
}
