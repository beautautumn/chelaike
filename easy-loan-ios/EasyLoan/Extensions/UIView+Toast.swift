import Toast_Swift

extension UIView {

    func showToast(_ message: String,
                   messageColor: UIColor = UIColor.white,
                   completion: ((Bool) -> Void)? = nil) {
        var style = ToastStyle()
        style.messageAlignment = NSTextAlignment.center
        style.messageColor = messageColor
        self.makeToast(message, duration: 2.0, position: .center, title: nil, image: nil, style: style, completion: completion)
    }

    func showRingLoading() {
        self.makeToastActivity(.center)
    }
    
    func hideRingLoading() {
        self.hideToastActivity()
    }
}
