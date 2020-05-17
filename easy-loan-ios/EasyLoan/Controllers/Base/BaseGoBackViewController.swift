import UIKit

class BaseGoBackViewController : BaseViewController, EnableNavigationGoBack {

    override func initNavigationController() {
        super.initNavigationController()
        self.enableNavigationGoBack()
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
