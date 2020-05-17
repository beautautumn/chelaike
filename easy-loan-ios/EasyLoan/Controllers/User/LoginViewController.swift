import UIKit
import Regex
import RxSwift
import SnapKit
import ZMKnife

class LoginViewController: BaseViewController {

    var messages: [String]?

    fileprivate let logoImageView = UIImageView()
    fileprivate let phoneTextField = PaddingTextField()
    fileprivate let tokenTextField = PaddingTextField()
    fileprivate let tokenButton = TimerButton()
    fileprivate let tokenSeparatorLine = UIView()
    fileprivate let loginButton = SubmitButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.logoImageView.image = UIImage(named: "app_logo")
        self.view.addSubview(self.logoImageView)
        self.logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(98)
            make.centerX.equalTo(self.view)
            make.size.equalTo(70)
        }

        self.phoneTextField.placeholder = "手机号"
        self.phoneTextField.keyboardType = UIKeyboardType.phonePad
        self.phoneTextField.backgroundColor = UIColor.white
        self.phoneTextField.font = UIFont.systemFont(ofSize: 14)
        self.phoneTextField.bottomBorderColor = ColorUtils.separatorColor
        self.phoneTextField.clearButtonMode = .whileEditing
        self.view.addSubview(self.phoneTextField)
        self.phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.top.equalTo(self.logoImageView.snp.bottom).offset(84)
            make.height.equalTo(40)
        }

        self.tokenTextField.placeholder = "验证码"
        self.tokenTextField.keyboardType = UIKeyboardType.numberPad
        self.tokenTextField.backgroundColor = UIColor.white
        self.tokenTextField.font = UIFont.systemFont(ofSize: 14)
        self.tokenTextField.clearButtonMode = .whileEditing
        self.view.addSubview(self.tokenTextField)
        self.tokenTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-130)
            make.top.equalTo(self.phoneTextField.snp.bottom)
            make.height.equalTo(40)
        }

        self.tokenButton.title = "发送验证码"
        self.view.addSubview(self.tokenButton)
        self.tokenButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.tokenTextField.snp.right)
            make.right.equalTo(self.view).offset(-40)
            make.top.equalTo(self.phoneTextField.snp.bottom)
            make.height.equalTo(40)
        }
        self.tokenButton.onClickedListener = { [unowned self] () in
            self.sendToken()
        }

        self.tokenSeparatorLine.backgroundColor = ColorUtils.separatorColor
        self.view.addSubview(self.tokenSeparatorLine)
        self.tokenSeparatorLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.top.equalTo(self.tokenTextField.snp.bottom).offset(-1)
            make.height.equalTo(1)
        }

        self.loginButton.title = "登录"
        self.view.addSubview(self.loginButton)
        self.loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.top.equalTo(self.tokenTextField.snp.bottom).offset(30)
            make.height.equalTo(38)
        }
        self.loginButton.setOnClickedListener { [unowned self] (_) in
            self.login()
        }

        if let messages = self.messages {
            if messages.count > 0 {
                self.view.showToast(messages.joined(separator: "\n"))
            }
        }
        
        JPUSHService.deleteAlias(nil, seq: 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tokenButton.stopTimer()
    }

    override func onUnauthorizedError(_ data: Any?) {
        self.onErrorHandler(data)
    }

    fileprivate func sendToken() {
        if let phoneNumberError = self.validatePhoneNumber() {
            self.view.showToast(phoneNumberError)
            return
        }
        let _ = UserApi.sendLoginToken(self.phoneTextField.text!)
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

    fileprivate func login() {
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
        let _ = UserApi.login(self.phoneTextField.text!, token: self.tokenTextField.text!)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (response, json) in
                if response.statusCode == 200 {
                    if let data = json as? [String: AnyObject] {
                        UserModel.login(data["data"] as! [String: AnyObject])
                    }
                    self.view.hideRingLoading()
                    self.present(MainViewController(), animated: true, completion: nil)
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

