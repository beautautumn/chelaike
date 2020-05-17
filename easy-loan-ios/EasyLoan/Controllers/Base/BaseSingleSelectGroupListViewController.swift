import UIKit
import SnapKit
import ZMKnife

class BaseSingleSelectGroupListViewController: BaseGoBackViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate var listViewCellIdentifier = ""
    var defaultSelectedKey: String?
    var noneValue: [String: Any]?
    var data: [[String: Any]] = []
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
        self.listView.rowHeight = UITableViewAutomaticDimension
        self.registerListCellViewClass(self.listView, cellIdentifier: self.listViewCellIdentifier)
        self.view.addSubview(self.listView)
        self.initListViewConstraints()
    }
    
    func initListViewConstraints() {
        self.listView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func initListViewDefaultSelected(_ defaultSelectedKey: String?) {
        var defalutSelectedKeySectionIndex = -1
        var defalutSelectedKeyRowIndex = -1
        self.defaultSelectedKey = defaultSelectedKey
        if !(self.defaultSelectedKey?.isEmpty ?? true) {
            for (sectionIndex, group) in self.data.enumerated() {
                if let itemRecord = group["data"] as? [[String: String]] {
                    for (rowIndex, item) in itemRecord.enumerated() {
                        if self.defaultSelectedKey == item["key"] {
                            defalutSelectedKeySectionIndex = sectionIndex
                            defalutSelectedKeyRowIndex = rowIndex
                        }
                    }
                }
            }
        }

        if defalutSelectedKeySectionIndex > -1 {
            self.listView.selectRow(at: IndexPath(row: defalutSelectedKeyRowIndex, section: defalutSelectedKeySectionIndex),
                                    animated: true,
                                    scrollPosition: .none)
            self.listView.scrollToRow(at: IndexPath(row: defalutSelectedKeyRowIndex, section: defalutSelectedKeySectionIndex),
                                      at: .top,
                                      animated: false)
        }
    }
    
    func registerListCellViewClass(_ listView: UITableView, cellIdentifier: String) {
        listView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.noneValue == nil ? 16.0 : (section > 0 ? 16.0 : 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.data.map { group in (group["letter"] as? String)! }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itemRecord = self.data[section]["data"] as? [[String: String]] {
            return itemRecord.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 || self.noneValue == nil {
            if let firstLetter = self.data[section]["letter"] as? String {
                let headerView = PaddingLabel()
                headerView.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                headerView.text = firstLetter
                headerView.textColor = ColorUtils.fontColor
                headerView.font = UIFont.systemFont(ofSize: 12)
                headerView.backgroundColor = ColorUtils.separatorColor
                return headerView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.listViewCellIdentifier, for: indexPath)
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        if let itemRecord = self.data[sectionIndex]["data"] as? [[String: String]] {
            cell.textLabel?.text = itemRecord[rowIndex]["value"]
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.highlightedTextColor = ColorUtils.primaryColor
        cell.selectedBackgroundView = SingleSelectedView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    
    func reloadData(_ data: [[String: Any]], noneValue: [String: String]?, defaultSelectedKey: String? = nil) {
        self.noneValue = noneValue
        if self.noneValue != nil {
            self.data = [["letter": "☆", "data": [self.noneValue]]] + data
        } else {
            self.data = data
        }
        self.listView.reloadData()
        self.initListViewDefaultSelected(defaultSelectedKey)
    }
}
