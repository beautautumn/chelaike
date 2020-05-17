import UIKit
import SnapKit
import RxSwift
import ESPullToRefresh

class BaseDetailViewController: BaseScrollViewController {

    weak var delegate: BaseDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.es.addPullToRefresh { [unowned self] in
            self.refresh(false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }

    final func refresh(_ showLoading: Bool = true) {
        if showLoading {
            self.view.showRingLoading()
        }
        if let response = self.delegate?.query() {
            let _ = response.subscribeOn(ConcurrentMainScheduler.instance)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] (response, json) in
                    if response.statusCode == 200 {
                        self.scrollView.es.stopPullToRefresh()
                        self.view.hideRingLoading()
                        if let data = (json as? [String: AnyObject])?["data"] as? [String: AnyObject] {
                            self.delegate?.reloadData(data)
                        }
                    } else {
                        self.scrollView.es.stopPullToRefresh()
                        self.onHttpError(response, data: json)
                    }
                })
        } else {
            self.scrollView.es.stopPullToRefresh()
            self.view.hideRingLoading()
        }
    }
}
