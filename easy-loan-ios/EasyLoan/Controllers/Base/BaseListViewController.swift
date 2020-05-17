import UIKit
import SnapKit
import RxSwift
import ESPullToRefresh

class BaseListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    fileprivate let listView = UITableView()
    fileprivate var listViewCellIdentifier = ""

    fileprivate var total = 0
    fileprivate var perPage = 15
    fileprivate var currentPage = 0
    fileprivate var tmpPerPage = 15
    fileprivate var tmpCurrentPage = 0
    fileprivate var isDataLoading = false
    fileprivate var preserveData = false {
        didSet {
            if preserveData {
                tmpCurrentPage = currentPage > 0 ? (currentPage - 1) : 0
                tmpPerPage = perPage
                perPage = (tmpCurrentPage + 1) * tmpPerPage
            } else if oldValue {
                perPage = tmpPerPage
                currentPage = tmpCurrentPage
            }
        }
    }

    var data: [AnyObject] = []
    weak var listViewDelegate: BaseListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.listViewCellIdentifier = "\(String(describing: type(of: self)))::TableViewCell"
        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.allowsSelection = false
        self.listView.separatorStyle = .none
        self.listView.separatorInset = UIEdgeInsets.zero
        self.listView.tableFooterView = UIView(frame: CGRect.zero)
        self.listView.backgroundColor = ColorUtils.separatorColor
        self.listView.cellLayoutMarginsFollowReadableWidth = false
        self.listView.keyboardDismissMode = .onDrag
        self.registerListCellViewClass(self.listView, cellIdentifier: self.listViewCellIdentifier)
        self.view.addSubview(self.listView)
        self.initListViewConstraints(self.listView)
        self.listView.es.addPullToRefresh { [unowned self] in
            self.refresh(false)
        }
        self.listView.es.addInfiniteScrolling { [unowned self] in
            self.loadMore()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.preserveData = self.currentPage > 0
        self.refresh()
    }

    @objc final func refresh(_ showLoading: Bool = true) {
        self.currentPage = 0
        self.listView.es.resetNoMoreData()
        if showLoading {
            self.view.showRingLoading()
        }
        loadData()
    }
    
    fileprivate func loadMore() {
        if self.data.count == self.total {
            self.listView.es.stopLoadingMore()
            self.listView.es.noticeNoMoreData()
        } else {
            loadData()
        }
    }

    fileprivate func loadData() {
        self.isDataLoading = true
        if let response = self.listViewDelegate?.query(self.currentPage, perPage: self.perPage) {
            let _ = response.subscribeOn(ConcurrentMainScheduler.instance)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self] (response, json) in
                    self.parseData(response: response, json: json)
                })
        } else {
            self.isDataLoading = false
            self.listView.es.stopPullToRefresh()
            self.listView.es.stopLoadingMore()
            self.view.hideRingLoading()
        }
    }

    fileprivate func parseData(response: HTTPURLResponse, json: Any) {
        self.isDataLoading = false
        if response.statusCode == 200 {
            self.view.hideRingLoading()
            self.preserveData = false
            if let record = json as? [String: Any] {
                if let data = record["data"] as? [String: Any] {
                    self.total = (data["totalElements"] as? Int) ?? 0
                    if let content = data["content"] as? [AnyObject] {
                        if self.currentPage == 0 || self.data.count == self.total {
                            self.data = content
                        } else {
                            self.data += content
                        }
                        self.listView.reloadData()
                        self.listView.es.stopPullToRefresh()
                        self.listView.es.stopLoadingMore()
                        if self.data.count < self.total {
                            self.currentPage += 1
                        } else {
                            self.listView.es.noticeNoMoreData()
                        }
                    }
                }
            }
        } else {
            self.listView.es.stopPullToRefresh()
            self.listView.es.stopLoadingMore()
            self.onHttpError(response, data: json)
        }
    }

    func initListViewConstraints(_ listView: UITableView) {
        listView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }

    func registerListCellViewClass(_ listView: UITableView, cellIdentifier: String) {
        listView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel()
        headerView.text = "共\(self.total)条记录"
        headerView.textColor = ColorUtils.fontColor
        headerView.font = UIFont.systemFont(ofSize: 10)
        headerView.textAlignment = NSTextAlignment.center
        headerView.backgroundColor = ColorUtils.recordCountBgColor
        return headerView
    }

    final func numberOfSections(in tableView: UITableView) -> Int {
        if self.data.count == 0 {
            if self.isDataLoading {
                return 0
            }
            let size = self.listView.bounds.size
            let backgroundView = UIView()
            let label = UILabel(frame: CGRect(x: 0, y: 100, width: size.width, height: 14))
            label.text = self.listViewDelegate?.listViewEmptyText()
            label.textAlignment = .center
            label.textColor = ColorUtils.grayTextColor
            label.font = UIFont.systemFont(ofSize: 14)
            backgroundView.addSubview(label)
            self.listView.backgroundView = backgroundView
            return 0
        }
        self.listView.backgroundView = nil
        return 1
    }

    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = self.listViewCellIdentifier
        let cell = self.listViewDelegate?.getListCellView(tableView, cellIdentifier: identifier, indexPath: indexPath) ?? tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onItemViewClicked(_:))))
        return cell
    }

    @objc func onItemViewClicked(_ recognizer: UITapGestureRecognizer) {
        if let tag = recognizer.view?.tag {
            self.listViewDelegate?.onListCellViewClicked(self.data[tag])
        }
    }
}
