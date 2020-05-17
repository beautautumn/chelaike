import UIKit

typealias UIButtonClickedListener = (UIButton) -> ()

extension UIButton {

    private struct Keys {
        static var clickedListener = "clickedListener"
    }

    private var clickedListener: UIButtonClickedListener? {
        get {
            return objc_getAssociatedObject(self, &Keys.clickedListener) as? UIButtonClickedListener
        }
        set(newValue) {
            objc_setAssociatedObject(self, &Keys.clickedListener, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setOnClickedListener(listener: @escaping UIButtonClickedListener) {
        clickedListener = listener
        addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
    }

    @objc func onButtonClicked() {
        if let listener = self.clickedListener {
            listener(self)
        }
    }
}
