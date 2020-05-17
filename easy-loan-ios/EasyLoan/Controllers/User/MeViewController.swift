import UIKit
import RxSwift
import SnapKit
import ZMKnife

class MeViewController: BaseViewController {

    fileprivate let nameView = RightIconTitleAndValueTextView()
    fileprivate let phoneView = RightIconTitleAndValueTextView()
    fileprivate let companyView = RightIconTitleAndValueTextView()
    fileprivate let logoutButton = SubmitButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameView.titleLabel.text = "姓名"
        self.view.addSubview(self.nameView)
        self.nameView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(44)
        }
        self.nameView.onClickedListener = { [unowned self] () in
            let controller = UserNameEditViewController()
            controller.name = self.nameView.valueLabel.text
            let navigation = UINavigationController(rootViewController: controller)
            self.present(navigation, animated: true, completion: nil)
        }

        self.phoneView.titleLabel.text = "电话"
        self.view.addSubview(self.phoneView)
        self.phoneView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.nameView.snp.bottom)
            make.height.equalTo(44)
        }
        self.phoneView.onClickedListener = { [unowned self] () in
            let controller = UserPhotoEditViewController()
            let navigation = UINavigationController(rootViewController: controller)
            self.present(navigation, animated: true, completion: nil)
        }

        self.companyView.titleLabel.text = "我的商家"
        self.view.addSubview(self.companyView)
        self.companyView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.phoneView.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        self.companyView.onClickedListener = { [unowned self] () in
            let controller = CompanyListViewController()
            let navigation = UINavigationController(rootViewController: controller)
            self.present(navigation, animated: true, completion: nil)
        }

        self.logoutButton.title = "安全退出"
        self.view.addSubview(self.logoutButton)
        self.logoutButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.companyView.snp.bottom).offset(116)
            make.height.equalTo(40)
        }
        self.logoutButton.setOnClickedListener { [unowned self] (_) in
            UserModel.logout()
            Utils.redirectToLogin(self)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }

    fileprivate func refresh() {
        self.view.showRingLoading()
        let _ = UserApi.own().subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    if let data = (json as? [String: Any])?["data"] as? [String: Any] {
                        self.nameView.valueLabel.text = data["name"] as? String
                        self.phoneView.valueLabel.text = data["phone"] as? String
                        self.companyView.valueLabel.text = "\((data["storeNum"] as? Int) ?? 0)家"
                    }
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }
}
