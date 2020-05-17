import UIKit
import SnapKit

class BaseSingleSelectListViewController: BaseGoBackViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate var listViewCellIdentifier = ""
    var defaultSelectedKey: String?
    fileprivate var data: [[String: String]] = []
    fileprivate var noneValue: [String: String]?
    fileprivate let listView = UITableView()

    var onSelected: (([String: String]?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.listViewCellIdentifier = "\(String(describing: type(of: self)))::TableViewCell"

        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.separatorColor = ColorUtils.separatorColor
        self.listView.separatorInset = UIEdgeInsets.zero
        self.listView.tableFooterView = UIView(frame: CGRect.zero)
        self.listView.backgroundColor = ColorUtils.separatorColor
        self.listView.cellLayoutMarginsFollowReadableWidth = false
        self.listView.keyboardDismissMode = .onDrag
        self.listView.estimatedRowHeight = 44
        self.listView.rowHeight = UITableViewAutomaticDimension
        self.registerListCellViewClass(self.listView, cellIdentifier: self.listViewCellIdentifier)
        self.view.addSubview(self.listView)
        self.initListViewConstraints()
    }

    func registerListCellViewClass(_ listView: UITableView, cellIdentifier: String) {
        listView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }

    func initListViewConstraints() {
        self.listView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }

    func initListViewDefaultSelected(_ defaultSelectedKey: String?) {
        var defalutSelectedKeyIndex = -1
        self.defaultSelectedKey = defaultSelectedKey
        if !(self.defaultSelectedKey?.isEmpty ?? true) {
            defalutSelectedKeyIndex = self.data.index(where: { (item) -> Bool in
                return item["key"] == self.defaultSelectedKey
            }) ?? -1
        }
        if self.noneValue != nil {
            defalutSelectedKeyIndex += 1
        }
        if defalutSelectedKeyIndex > -1 {
            self.listView.selectRow(at: IndexPath(row: defalutSelectedKeyIndex, section: 0),
                                    animated: true,
                                    scrollPosition: .none)
            if defalutSelectedKeyIndex > 0 {
                self.listView.scrollToRow(at: IndexPath(row: defalutSelectedKeyIndex - 1, section: 0),
                                          at: .top,
                                          animated: false)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.noneValue == nil {
            return self.data.count
        }
        return self.data.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.listViewCellIdentifier, for: indexPath)
        let rowIndex = indexPath.row
        if let none = self.noneValue {
            if rowIndex == 0 {
                cell.textLabel?.text = none["value"]
            } else {
                cell.textLabel?.text = self.data[rowIndex - 1]["value"]
            }
        } else {
            cell.textLabel?.text = self.data[rowIndex]["value"]
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.highlightedTextColor = ColorUtils.primaryColor
        cell.selectedBackgroundView = SingleSelectedView()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowIndex = indexPath.row
        var record: [String: String]? = nil
        if self.noneValue == nil {
            record = self.data[rowIndex]
        } else if rowIndex != 0 {
            record = self.data[rowIndex - 1]
        }
        if let callback = self.onSelected {
            callback(record)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted = false
    }

    func reloadData(_ data: [[String: String]], noneValue: [String: String]?, defaultSelectedKey: String? = nil) {
        self.data = data
        self.noneValue = noneValue
        self.listView.reloadData()
        self.initListViewDefaultSelected(defaultSelectedKey)
    }
}
