import UIKit
import SnapKit

class BaseScrollViewController: BaseViewController, EnableNavigationGoBack {

    let contentView = UIStackView()
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.scrollsToTop = false
        self.view.addSubview(self.scrollView)
        self.initScrollViewConstraints()
        self.contentView.axis = .vertical
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
    }
    
    override func initNavigationController() {
        super.initNavigationController()
        if self.isEnableNavigationGoBack() {
            self.enableNavigationGoBack()
        }
    }

    func initScrollViewConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    func isEnableNavigationGoBack() -> Bool {
        return true
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
