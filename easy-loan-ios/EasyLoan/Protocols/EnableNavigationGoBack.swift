import UIKit
import SnapKit

protocol EnableNavigationGoBack where Self:UIViewController {

    func enableNavigationGoBack()
    func onNavigationGoBackViewClicked()
}

extension EnableNavigationGoBack where Self:UIViewController {

    func enableNavigationGoBack() {
        let goBackView = UIButton(type: UIButtonType.custom)
        if #available(iOS 11, *) {
            goBackView.snp.makeConstraints { (make) in
                make.width.equalTo(13)
                make.height.equalTo(21)
            }
        } else {
            goBackView.frame = CGRect(x: 0, y: 0, width: 13, height: 21)
        }
        goBackView.setImage(UIImage.init(named: "go_back"), for: UIControlState.normal)
        goBackView.setOnClickedListener { [unowned self] (_) in
            self.onNavigationGoBackViewClicked()
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: goBackView)
    }
}
