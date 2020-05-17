import UIKit
import Regex
import RxSwift
import SnapKit
import ZMKnife

class UserPhotoEditViewController: BaseGoBackViewController {

    fileprivate let phoneTextField = PaddingTextField()
    fileprivate let tokenTextField = PaddingTextField()
    fileprivate let tokenButton = TimerButton()
    fileprivate let submitButton = SubmitButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "更改电话"

        self.phoneTextField.placeholder = "请输入手机号"
        self.phoneTextField.font = UIFont.systemFont(ofSize: 14)
        self.phoneTextField.backgroundColor = UIColor.white
        self.phoneTextField.clearButtonMode = .whileEditing
        self.phoneTextField.bottomBorderColor = ColorUtils.separatorColor
        self.phoneTextField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.phoneTextField.keyboardType = UIKeyboardType.phonePad
        self.view.addSubview(self.phoneTextField)
        self.phoneTextField.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(44)
        }

        self.tokenTextField.placeholder = "请输入短信验证码"
        self.tokenTextField.font = UIFont.systemFont(ofSize: 14)
        self.tokenTextField.backgroundColor = UIColor.white
        self.tokenTextField.clearButtonMode = .whileEditing
        self.tokenTextField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.tokenTextField.keyboardType = UIKeyboardType.numberPad
        self.view.addSubview(self.tokenTextField)
        self.tokenTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view).offset(-90)
            make.top.equalTo(self.phoneTextField.snp.bottom)
            make.height.equalTo(44)
        }

        self.tokenButton.title = "发送验证码"
        self.view.addSubview(self.tokenButton)
        self.tokenButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.tokenTextField.snp.right)
            make.right.equalTo(self.view)
            make.top.equalTo(self.phoneTextField.snp.bottom)
            make.height.equalTo(44)
        }
        self.tokenButton.onClickedListener = { [unowned self] () in
            self.sendToken()
        }

        self.submitButton.title = "保存"
        self.view.addSubview(self.submitButton)
        self.submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.tokenTextField.snp.bottom).offset(94)
            make.height.equalTo(40)
        }
        self.submitButton.setOnClickedListener { [unowned self] (_) in
            self.submit()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tokenButton.stopTimer()
    }

    fileprivate func sendToken() {
        if let phoneNumberError = self.validatePhoneNumber() {
            self.view.showToast(phoneNumberError)
            return
        }
        let _ = UserApi.sendUpdatePhoneToken(self.phoneTextField.text!)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.tokenButton.startTimer()
                    self.view.showToast("验证码已发送，请注意查收")
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }

    fileprivate func submit() {
        var errors = [String]()
        if let phoneNumberError = self.validatePhoneNumber() {
            errors.append(phoneNumberError)
        }
        if self.tokenTextField.text?.isEmpty ?? true {
            errors.append("验证码不能为空")
        }
        if errors.count > 0 {
            self.view.showToast(errors.joined(separator: "\n"))
            return
        }
        self.view.showRingLoading()
        let _ = UserApi.updatePhone(self.phoneTextField.text!, token: self.tokenTextField.text!)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    self.view.hideRingLoading()
                    Utils.redirectToLogin(self, messages: ["手机号已重置，请重新登录"])
                } else {
                    self.onHttpError(response, data: json)
                }
            })
    }

    fileprivate func validatePhoneNumber() -> String? {
        let phone = self.phoneTextField.text!
        if phone.isEmpty {
            return "手机号不能为空"
        }
        if !Regex("^1(\\d){10}$").matches(phone) {
            return "请输入正确的手机号码"
        }
        return nil
    }
}
