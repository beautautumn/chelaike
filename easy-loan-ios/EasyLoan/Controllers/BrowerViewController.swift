import UIKit
import WebKit
import SnapKit

class BrowerViewController: BaseGoBackViewController, WKNavigationDelegate, WKUIDelegate {

    var pageTitle: String?
    var pageUrl: String?

    fileprivate let webView = WKWebView()
    fileprivate let progressView = UIProgressView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = pageTitle

        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        self.progressView.frame = CGRect(x: 0, y: 42, width: UIScreen.main.bounds.size.width, height: 2)
        self.progressView.trackTintColor = UIColor.white
        self.progressView.progressTintColor = UIColor.orange
        self.navigationController?.navigationBar.addSubview(self.progressView)

        if let url = self.pageUrl {
            self.webView.load(URLRequest(url: URL(string: url)!))
        }
    }
    
    override func onNavigationGoBackViewClicked() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            super.onNavigationGoBackViewClicked()
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            self.progressView.isHidden = self.webView.estimatedProgress >= 1
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.progressView.setProgress(0, animated: false)
    }

    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.progressView.reloadInputViews()
    }
}
