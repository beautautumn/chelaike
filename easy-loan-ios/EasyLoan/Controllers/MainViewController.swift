import UIKit

class MainViewController: UITabBarController {
    
    fileprivate let tabs = [
            ["title": "借款", "icon_prefix": "loan", "authorities": ["借款单查看"], "controller": LoanListViewController()],
            ["title": "换车", "icon_prefix": "replace", "authorities": ["换车单查看"], "controller": ReplaceListViewController()],
            ["title": "还款", "icon_prefix": "repayment", "authorities": ["还款单查看"], "controller": RepaymentListViewController()],
            ["title": "盘库", "icon_prefix": "statistics", "authorities": ["盘库查看", "盘库管理"], "controller": StatisticsListViewController()],
            ["title": "我的", "icon_prefix": "me", "controller": MeTabsViewController()]
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabs = self.tabs.filter { (tab) -> Bool in
            if let authorities = tab["authorities"] as? [String] {
                return UserModel.isAnyAuthValid(authorities)
            }
            return true
        }
        self.viewControllers = tabs.map { (tab) -> UINavigationController in
            let controller = tab["controller"] as! UIViewController
            controller.title = tab["title"] as? String
            if let iconPrefix = tab["icon_prefix"] as? String {
                controller.tabBarItem.image = UIImage(named: "\(iconPrefix)_off")?.withRenderingMode(.alwaysOriginal)
                controller.tabBarItem.selectedImage = UIImage(named: "\(iconPrefix)_on")?.withRenderingMode(.alwaysOriginal)
                controller.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ColorUtils.primaryColor], for: UIControlState.selected)
            }
            return UINavigationController(rootViewController: controller)
        }
        self.tabBar.isTranslucent = false
        if let currentUser = UserModel.currentUser() {
            JPUSHService.setAlias(String(currentUser.id), completion: nil, seq: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(openMessageTab),
                                               name: NSNotification.Name("MessageTaped"),
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("MessageTaped"),
                                                  object: nil)
    }
    
    @objc final func openMessageTab() {
        let meTabsControllerIndex = self.tabs.count - 1
        let meTabsController = self.tabs[meTabsControllerIndex]["controller"] as! MeTabsViewController
        meTabsController.selectedTabIndex = 1
        self.selectedIndex = meTabsControllerIndex
    }
    
}
