import UIKit
import SnapKit
import RxSwift
import ZMKnife

class UserNameEditViewController: BaseGoBackViewController {
    
    var name: String?

    fileprivate let nameTextField = PaddingTextField()
    fileprivate let submitButton = SubmitButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "更改姓名"
    
        self.nameTextField.placeholder = "请输入姓名"
        self.nameTextField.text = self.name
        self.nameTextField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.nameTextField.backgroundColor = UIColor.white
        self.nameTextField.font = UIFont.systemFont(ofSize: 14)
        self.nameTextField.clearButtonMode = .whileEditing
        self.view.addSubview(self.nameTextField)
        self.nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(19)
            make.height.equalTo(44)
        }
        self.submitButton.title = "保存"
        self.view.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(120)
            make.height.equalTo(40)
        }
        self.submitButton.setOnClickedListener { [unowned self] (_) in
            self.submit()
        }
    }

    fileprivate func submit() {
        if self.nameTextField.text?.isEmpty ?? true {
            self.view.showToast("姓名不能为空")
            return
        }
        self.view.showRingLoading()
        let _ = UserApi.updateName(self.nameTextField.text!)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    Utils.redirectToLogin(self, messages: ["姓名已重置，请重新登录"])
                } else {
                    self.onHttpError(response, data: json)
                }
            })
        
    }
}
