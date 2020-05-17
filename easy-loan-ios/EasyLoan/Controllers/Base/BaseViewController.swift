import UIKit
import RxSwift
import Alamofire

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.separatorColor
        self.initNavigationController()
    }
    
    func initNavigationController() {
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = ColorUtils.primaryColor
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        }
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }

    func onHttpError(_ response: HTTPURLResponse?, data: Any?) {
        self.view.hideRingLoading()
        let statusCode = response?.statusCode
        if statusCode == 0 || statusCode == 408 || statusCode == 504 {
            self.onHttpTimeoutError()
        } else if statusCode == 401 {
            self.onUnauthorizedError(data)
        } else {
            self.onErrorHandler(data)
        }
    }

    func onHttpTimeoutError() {
        self.view.showTimeoutAlert()
    }

    func onUnauthorizedError(_ data: Any?) {
        Utils.redirectToLogin(self, messages: self.parseHttpErrors(data))
    }

    func onErrorHandler(_ data: Any?) {
        self.view.showToast(self.parseHttpErrors(data).joined(separator: "\n"))
    }

    fileprivate func parseHttpErrors(_ data: Any?) -> [String] {
        var messages = [String]()
        if let json = data as? [String: Any] {
            if let errorEntries = json["errors"] as? [String: [String: [String]]] {
                for (_, errorEntry) in errorEntries {
                    for (_, errors) in errorEntry {
                        messages += errors
                    }
                }
            } else if let message = json["errors"] as? String {
                messages.append(message)
            } else if let message = json["message"] as? String {
                messages.append(message)
            }
        }
        if messages.count == 0 {
            messages.append("网络请求失败，请稍后重试")
        }
        return messages
    }
}
